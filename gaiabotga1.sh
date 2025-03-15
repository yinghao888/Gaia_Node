#!/bin/bash

# Function to check if NVIDIA CUDA or GPU is present
check_cuda() {
    if command -v nvcc &> /dev/null || command -v nvidia-smi &> /dev/null; then
        echo "✅ NVIDIA GPU with CUDA detected. Proceeding with execution..."
    else
        echo "❌ NVIDIA GPU Not Found. This Bot is Only for GPU Users."
        echo "Press Enter to go back and Run on GPU Device..."  
        read -r  # Waits for user input

        # Restart installer
        rm -rf GaiaNodeInstallet.sh
        curl -O https://raw.githubusercontent.com/abhiag/Gaianet_installer/main/GaiaNodeInstallet.sh && chmod +x GaiaNodeInstallet.sh && ./GaiaNodeInstallet.sh

        exit 1
    fi
}

# Run the check
check_cuda

# Check if jq is installed, and if not, install it
if ! command -v jq &> /dev/null; then
    echo "❌ jq not found. Installing jq..."
    sudo apt update && sudo apt install jq -y
    if [ $? -eq 0 ]; then
        echo "✅ jq installed successfully!"
    else
        echo "❌ Failed to install jq. Please install jq manually and re-run the script."
        exit 1
    fi
else
    echo "✅ jq is already installed."
fi

# List of general questions
general_questions=( 
    "What color is the sky?"
    "How many legs does a dog have?"
    "What sound does a cat make?"
    "Which number comes after 4?"
    "What is the opposite of 'hot'?"
    "What do you use to brush your teeth?"
    "What is the first letter of the alphabet?"
    "What shape is a football?"
    "How many fingers do humans have?"
    "What is 1 + 1?"
    "What do you wear on your feet?"
    "What animal says 'moo'?"
    "How many eyes does a person have?"
    "What do you call a baby dog?"
    "Which fruit is yellow and curved?"
    "What do you drink when you're thirsty?"
    "What do bees make?"
    "What is the name of our planet?"
    "What do you do with a book?"
    "What color is grass?"
    "What is the opposite of 'up'?"
    "How many wheels does a bicycle have?"
    "Where do fish live?"
    "What do you use to write on a blackboard?"
    "What shape is a pizza?"
    "What do you call a baby cat?"
    "What is 5 minus 2?"
    "What do you use to cut paper?"
    "What is the color of a banana?"
    "What do birds use to fly?"
    "What do you wear on your head to keep warm?"
    "How many days are in a week?"
    "What do you use an umbrella for?"
    "What does ice turn into when it melts?"
    "How many ears does a rabbit have?"
    "Which season comes after summer?"
    "What color is the sun?"
    "What do cows give us to drink?"
    "Which fruit is red and has seeds inside?"
    "What do you do with a bed?"
    "What sound does a duck make?"
    "How many toes do you have?"
    "What do you call a baby chicken?"
    "What do you put on your cereal?"
    "Which is bigger, an elephant or a mouse?"
    "What do you do with a spoon?"
    "How many arms does an octopus have?"
    "What is the color of a strawberry?"
    "Which day comes after Monday?"
    "What do you use to open a door?"
    "What sound does a cow make?"
    "Where do penguins live?"
    "What do you call a baby horse?"
    "What do you use to write on paper?"
    "Which is faster, a car or a bicycle?"
    "How many ears does a human have?"
    "What do you wear on your hands when it’s cold?"
    "What do you use to see things?"
    "What do you do with a pillow?"
    "How many arms does a starfish have?"
    "What is the color of a lemon?"
    "What do you call a house for birds?"
    "Where do chickens live?"
    "Which is taller, a giraffe or a cat?"
    "What do you use to comb your hair?"
    "What do you call a baby sheep?"
    "How many hands does a clock have?"
    "What do you call a place with lots of books?"
    "Which animal has a long trunk?"
    "What is the color of a watermelon?"
    "What do you do with a TV?"
    "What is the opposite of small?"
    "How many sides does a triangle have?"
    "What do you call a group of stars in the sky?"
    "What do you use to eat soup?"
    "What do you use to clean your hands?"
    "What do monkeys love to eat?"
    "Where do polar bears live?"
    "What do you call a baby cow?"
    "What does a clock show?"
    "What do you wear when it’s raining?"
    "What is something that barks?"
    "What do you use to make a phone call?"
    "What do you use to wash your hair?"
    "What do you do with a blanket?"
    "Which animal can hop and has a pouch?"
    "What do you call a baby duck?"
    "What do you use to tie your shoes?"
    "How many wings does a butterfly have?"
    "What do you wear to protect your eyes from the sun?"
    "What do you do with a birthday cake?"
    "What do you wear on your wrist to tell time?"
    "What do you call a baby frog?"
    "What do you eat for breakfast?"
    "What do you do when you’re sleepy?"
    "What is the color of the moon?"
    "How many legs does a spider have?"
    "Where do turtles live?"
    "What do you do with a soccer ball?"
    "What do you call a baby fish?"
    "What do you wear on your head when riding a bike?"
    "What do you do when you hear music?"

)

# Function to get a random general question
generate_random_general_question() {
    echo "${general_questions[$RANDOM % ${#general_questions[@]}]}"
}

# Function to handle the API request
send_request() {
    local message="$1"
    local api_key="$2"

    echo "📬 Sending Question: $message"

    json_data=$(cat <<EOF
{
    "messages": [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "$message"}
    ]
}
EOF
    )

    response=$(curl -s -w "\n%{http_code}" -X POST "$API_URL" \
        -H "Authorization: Bearer $api_key" \
        -H "Accept: application/json" \
        -H "Content-Type: application/json" \
        -d "$json_data")

    http_status=$(echo "$response" | tail -n 1)
    body=$(echo "$response" | head -n -1)

    # Extract the 'content' from the JSON response using jq (Suppress errors)
    response_message=$(echo "$body" | jq -r '.choices[0].message.content' 2>/dev/null)

    if [[ "$http_status" -eq 200 ]]; then
        if [[ -z "$response_message" ]]; then
            echo "⚠️ Response content is empty!"
        else
            ((success_count++))  # Increment success count
            echo "✅ [SUCCESS] Response $success_count Received!"
            echo "📝 Question: $message"
            echo "💬 Response: $response_message"
        fi
    else
        echo "⚠️ [ERROR] API request failed | Status: $http_status | Retrying..."
        sleep 2
    fi
}

# Asking for API Key (loops until a valid key is provided)
while true; do
    echo -n "Enter your API Key: "
    read -r api_key

    if [ -z "$api_key" ]; then
        echo "❌ Error: API Key is required!"
        echo "🔄 Restarting the installer..."

        # Restart installer
        rm -rf GaiaNodeInstallet.sh
        curl -O https://raw.githubusercontent.com/abhiag/Gaianet_installer/main/GaiaNodeInstallet.sh && chmod +x GaiaNodeInstallet.sh && ./GaiaNodeInstallet.sh

        exit 1
    else
        break  # Exit loop if API key is provided
    fi
done

# Asking for duration
echo -n "⏳ How many hours do you want the bot to run? "
read -r bot_hours

# Convert hours to seconds
if [[ "$bot_hours" =~ ^[0-9]+$ ]]; then
    max_duration=$((bot_hours * 3600))
    echo "🕒 The bot will run for $bot_hours hour(s) ($max_duration seconds)."
else
    echo "⚠️ Invalid input! Please enter a number."
    exit 1
fi

# Hidden API URL (moved to the bottom)
API_URL="https://soneium.gaia.domains/v1/chat/completions"

# Display thread information
echo "✅ Using 1 thread..."
echo "⏳ Waiting 30 seconds before sending the first request..."
sleep 5

echo "🚀 Starting requests..."
start_time=$(date +%s)
success_count=0  # Initialize success counter

while true; do
    current_time=$(date +%s)
    elapsed=$((current_time - start_time))

    if [[ "$elapsed" -ge "$max_duration" ]]; then
        echo "🛑 Time limit reached ($bot_hours hours). Exiting..."
        echo "📊 Total successful responses: $success_count"
        exit 0
    fi

    random_message=$(generate_random_general_question)
    send_request "$random_message" "$api_key"
    sleep 2
done
