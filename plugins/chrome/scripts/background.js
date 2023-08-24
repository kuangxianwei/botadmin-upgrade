class Cookies {
    constructor(sender) {
        this.error = null;
        this.sender = sender;
        this.URL = new URL(sender.url);
        if (!this.URL) {
            this.error = "无效的URL: " + sender.url;
            return
        }
        this.domain = this.getFirstDomain();
        if (!this.domain) {
            this.error = "获取顶级域名失败: " + sender.url;
            return
        }
        this.cookies = [];
        this.parseCookies();
    }

    // getFirstDomain 获取顶级域名
    getFirstDomain() {
        const hostPattern = /[a-z0-9](?:[a-z0-9-]*?[a-z0-9])?\.(?:[a-z]{1,4}.cn|cn|com|net|cc|ph|info|org|hk|top|asia|biz|tv|mobi|me|co|vip|shop|ltd|group|xyz|site|io|de|uk|nl|ru|br)\b/i;
        const matches = hostPattern.exec(this.URL.hostname);
        if (matches && matches.length > 0) {
            return matches[0]
        }
        return ''
    }

    getUrl() {
        if (!this.URL.searchParams.has("cookies")) {
            return
        }
        this.URL.searchParams.delete("cookies");
        const params = this.URL.searchParams.toString();
        return this.URL.origin + this.URL.pathname + (params ? '?' : '') + params;
    }

    // parseCookies 解析cookies
    parseCookies() {
        const cookiesParam = this.URL.searchParams.get("cookies");
        if (!cookiesParam) return;
        try {
            let cookies = JSON.parse(decodeURIComponent(cookiesParam));
            if (Object.prototype.toString.call(cookies) === "[object Object]") {
                cookies = [cookies]
            }
            if (Array.isArray(cookies)) {
                for (let i = 0; i < cookies.length; i++) {
                    let cookie = cookies[i];
                    if (cookie.name && cookie.value) {
                        if (!cookie.hasOwnProperty("domain")) {
                            cookie.domain = "." + this.domain;
                        }
                        if (!cookie.hasOwnProperty("path")) {
                            cookie.path = "/";
                        }
                        if (!cookie.hasOwnProperty("expirationDate")) {
                            const date = new Date();
                            date.setTime(date.getTime() + (365 * 24 * 60 * 60 * 1000));
                            cookie.expirationDate = date.getTime();
                        }
                        if (!cookie.hasOwnProperty("url")) {
                            cookie.url = this.URL.origin;
                        }
                        this.cookies.push(cookie)
                    }
                }
            }
        } catch (e) {
            this.error = "解析cookies错误: " + e.message
        }
    }

    // existCookies 判断cookies已经存在
    async existCookies() {
        for (let i = 0; i < this.cookies.length; i++) {
            let cookie = await chrome.cookies.get({url: this.URL.origin, name: this.cookies[i].name});
            if (!cookie || cookie.value !== this.cookies[i].value) {
                return false
            }
        }
        return true
    }

    // editCookies 编辑cookies
    async editCookies() {
        if (await this.existCookies()) {
            return {url: this.getUrl()}
        }
        console.log(await this.deleteDomainCookies());
        if (this.error) {
            return {error: this.error}
        }
        let pending = this.cookies.map(this.setCookie);
        await Promise.all(pending);
        console.log("成功添加cookie: " + pending.length + "个");
        return {url: this.getUrl()}
    }

    // deleteDomainCookies 删除指定域名的全部cookies
    async deleteDomainCookies() {
        let cookiesDeleted = 0;
        try {
            const cookies = await chrome.cookies.getAll({domain: this.domain});
            if (cookies.length > 0) {
                let pending = cookies.map(this.deleteCookie);
                await Promise.all(pending);
                cookiesDeleted = pending.length;
            }
        } catch (error) {
            this.error = error.message;
            return `Unexpected error: ${error.message}`;
        }
        return `Deleted ${cookiesDeleted} cookie(s).`;
    }

    // deleteCookie 删除单个cookie
    deleteCookie(cookie) {
        const protocol = cookie.secure ? 'https:' : 'http:';
        return chrome.cookies.remove({
            url: `${protocol}//${cookie.domain}${cookie.path}`,
            name: cookie.name,
            storeId: cookie.storeId
        });
    }

    // setCookie 设置单个cookie
    setCookie(cookie) {
        return chrome.cookies.set(cookie)
    }
}

chrome.runtime.onMessage.addListener(function (request, sender, sendResponse) {
    switch (request.type) {
        case "cookies":
            const c = new Cookies(sender);
            if (c.error) {
                sendResponse({error: c.error});
                return false
            }
            if (!c.cookies) {
                return false
            }
            c.editCookies().then(sendResponse);
            break;
    }
    return true;
});