# Voice-service setup

This is an application for the Development and Integration exam.

1. Clone the repository:

`git clone https://github.com/alexsp63/voice-service.git`

2. Copy `.env` and `config/database.yml` configuration files from their examples:

`cp .env.sample`

`cp config/database.yml.sample config/database.yml`

3. Specify your credentials in them.

4. Run application with Docker, just use

`docker compose up`

It will create the database and sample data.

5. Make a request:

`curl --location 'http://0.0.0.0:3001/voice' \
--header 'Content-Type: application/json' \
--header 'Cookie: __profilin=p%3Dt' \
--data '{
    "user_id": 1,   
    "from": "1234567890", 
    "to": "9087654321", 
    "text": "hi" 
}'`
