url = "https://httparrot.herokuapp.com/post"
body = ~s({"name": "larry", "amount": 10})
{:ok, response} = HTTPoison.post url, body

# With headers
headers = [{"Content-Type", "application/json"}]
{:ok, response} = HTTPoison.post url, body, headers

response.status_code
# 200

# Parse to an Elixir map
Poison.Parser.parse!(response.body, %{})
