chrome.runtime.sendMessage({type: "cookies"}, function (res) {
    if (!res) return;
    if (res.url) {
        window.open(res.url, "_self");
    } else if (res.error) {
        console.log(res.error)
    }
});