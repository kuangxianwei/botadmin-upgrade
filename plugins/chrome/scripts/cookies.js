chrome.runtime.sendMessage({type: "twitterCookies"}, function (url) {
    if (url) {
        window.open(url, "_self");
    }
});