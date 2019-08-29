---
---
index = []
search_box = document.getElementById 'search-box'
search_results = document.getElementById 'search-results'

loadIndex = (callback) ->
    req = new XMLHttpRequest()
    req.onreadystatechange = () ->
        if req.readyState != XMLHttpRequest.DONE
            return
        index = JSON.parse(req.response)
        callback()
    req.open 'GET', '/search.json'
    req.send null

show = (item) ->
    search_results.innerHTML += """
    <div class="post-tile gui">
        <a class="post-link" href="#{item.url}">#{item.title}</a>
    </div>"""

search = ->
    term = search_box.value.toLowerCase()
    search_results.innerHTML = ''
    if term.length < 4
        return
    index
        .filter (item) -> item.title.toLowerCase().indexOf(term) != -1
        .forEach (item) -> show item

search_box.oninput = search
window.onload = () ->
    query = window.location.search
    params = new URLSearchParams(query);
    search_box.value = params.get 'q' if query
    loadIndex () ->
        search()