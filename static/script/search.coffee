---
---
index = []
search_box = document.getElementById 'search-field'
search_results = document.getElementById 'search-results'
search_wrapper = document.getElementById 'search-wrapper'

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
        <div class="post-meta">
            <time class="post-date">#{item.date_published}</time>
            <span class="post-author">by #{item.author}</span>
        </div>
    </div>
    """

predicate = (words) ->
    return (item) ->
        title = item.title.toLowerCase()
        series = if item.series then item.series.toLowerCase() else ""
        scores = []
        # console.log terms
        for word in words
            score = 0
            for tag in item.tags
                if tag.indexOf(word) != -1 then score += 1
            if title.indexOf(word) != -1 then score += 1
            if series.indexOf(word) != -1 then score += 1
            scores.push score
        scores.indexOf(0) == -1
        #item.title.toLowerCase().indexOf(term) != -1

search = ->
    term = search_box.value.toLowerCase()
    search_results.innerHTML = ''
    search_wrapper.style.display = if term.length > 0 then 'block' else 'none'
    search_wrapper.scrollIntoView()
    if term.length < 3 then return
    words = term.trim().split(/\s+/)
    index
        .filter predicate words
        .forEach (item) -> show item
    # search_results.innerHTML.length > 0
        

search_box.oninput = search
window.onload = () ->
    query = window.location.search
    params = new URLSearchParams(query);
    search_box.value = params.get 'q' if query
    loadIndex () ->
        search()