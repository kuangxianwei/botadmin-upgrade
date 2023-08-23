chrome.runtime.onMessage.addListener(function (request, sender, sendResponse) {
    switch (request.type) {
        case "twitterCookies":
            const U = new URL(sender.url);
            if (!U) {
                sendResponse("URL不合法");
                return
            }
            const token = U.searchParams.get("token");
            if (!token) return;
            const c = chrome.cookies.get({url: U.origin, name: "auth_token"});
            chrome.cookies.get({url: U.origin, name: "auth_token"}, function (res) {
                if (!res || res.value !== token) {
                    deleteDomainCookies(request.domain).then(function (r) {
                        console.log(r);
                        addCookie({
                            url: U.origin,
                            name: 'auth_token',
                            value: token,
                            domain: ".twitter.com",
                        }).then(function (res) {
                            sendResponse(U.origin + U.pathname);
                        });
                    });
                }
            });
    }
    return true;
});

async function deleteDomainCookies(domain) {
    let cookiesDeleted = 0;
    try {
        const cookies = await chrome.cookies.getAll({domain: domain});
        if (cookies.length === 0) {
            return 'No cookies found';
        }
        let pending = cookies.map(deleteCookie);
        await Promise.all(pending);
        cookiesDeleted = pending.length;
    } catch (error) {
        return `Unexpected error: ${error.message}`;
    }
    return `Deleted ${cookiesDeleted} cookie(s).`;
}

function deleteCookie(cookie) {
    const protocol = cookie.secure ? 'https:' : 'http:';
    return chrome.cookies.remove({
        url: `${protocol}//${cookie.domain}${cookie.path}`,
        name: cookie.name,
        storeId: cookie.storeId
    });
}

function addCookie(cookie) {
    const date = new Date();
    date.setTime(date.getTime() + (365 * 24 * 60 * 60 * 1000));
    cookie.expirationDate = date.getTime();
    cookie.path = "/";
    return chrome.cookies.set(cookie);
}