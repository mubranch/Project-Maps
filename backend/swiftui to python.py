import json
import requests

class OpenAIService:
    def __init__(self):
        self.api_handler = APIHandler()
        self.api_url = "https://api.openai.com/v1/chat/completions"  # You may need to adjust the API URL based on OpenAI's current endpoint.

    @property
    def api_key(self):
        return self.api_handler.open_ai_key

    def set_url(self, url):
        self.api_url = url

    def query(self, prompt):
        if not self.api_key:
            raise Exception("OpenAI API Key is missing")

        try:
            response_data = self.send_request(prompt)
            message = self.parse_response(response_data)
            print(message)
            return message
        except Exception as e:
            raise Exception(f"Failed to query OpenAI: {str(e)}")

    def send_request(self, prompt):
        if not self.api_url:
            raise Exception("Invalid API URL")

        headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json",
        }

        data = {
            "model": "gpt-3.5-turbo",
            "messages": [{"role": "user", "content": prompt}],
            "temperature": 0.7,
            "max_tokens": 500  # You can adjust as needed
        }

        try:
            response = requests.post(self.api_url, headers=headers, data=json.dumps(data))
            response.raise_for_status()
            return response.content
        except Exception as e:
            raise Exception(f"Failed to send request to OpenAI: {str(e)}")

    def parse_response(self, response_data):
        try:
            response_json = json.loads(response_data)
            print(response_json)
            return response_json
        except json.JSONDecodeError:
            return None
