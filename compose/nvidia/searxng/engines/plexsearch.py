from urllib.parse import urlencode
from json import loads

categories = ['media']
paging = False
language_support = False

base_url = ''
api_key = ''  # This will be injected from the engine config
server_id = ''  # Replace with dynamic source if needed
searchTypes = ''

def request(query, params):
    search_url = f'{base_url}/library/search?{urlencode({"query": query, "searchTypes": searchTypes})}'
    headers = {
        'X-Plex-Token': api_key,
        'Accept': 'application/json',
    }

    params['url'] = search_url
    params['headers'] = headers

    return params

def response(resp):
    results = []
    search_data = loads(resp.content)

    search_items = search_data.get('MediaContainer', {}).get('SearchResult', [])

    for item in search_items:
        metadata = item.get('Metadata')
        if metadata:
            key = metadata.get('key')
            title = metadata.get('title', 'Untitled')
            summary = metadata.get('summary', '')
            ratingKey = metadata.get('ratingKey')

            if key and ratingKey:
                encoded_key = urlencode({'key': key}).split('=')[1]
                webview_url = (
                    f"{base_url}/web/index.html#!/server/{server_id}/details"
                    f"?key={encoded_key}&context=home%3Ahub.continueWatching~0~0"
                )
            else:
                webview_url = base_url

            results.append({
                'title': title,
                'content': summary,
                'url': webview_url,
            })

    return results
