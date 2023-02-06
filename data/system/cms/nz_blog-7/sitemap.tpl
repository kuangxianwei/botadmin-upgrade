{{HTML "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>"}}
<urlset xmlns:mobile="http://www.baidu.com/schemas/sitemap-mobile/1/" xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    <url>
        <loc>{{.Config.Hostname}}/</loc>
        <mobile:mobile type="pc,mobile"/>
        <lastmod>{{date 0 "day"}}</lastmod>
        <changefreq>daily</changefreq>
        <priority>1.0</priority>
    </url>
    {{- range .Classes}}
    <url>
        <loc>{{.Url}}</loc>
        <mobile:mobile type="pc,mobile"/>
        <lastmod>{{date 0 "day"}}</lastmod>
        <changefreq>daily</changefreq>
        <priority>0.9</priority>
    </url>
    {{- if .Children}}
    {{- range .Children}}
    <url>
        <loc>{{.Url}}</loc>
        <mobile:mobile type="pc,mobile"/>
        <lastmod>{{date 0 "day"}}</lastmod>
        <changefreq>daily</changefreq>
        <priority>0.9</priority>
    </url>
    {{- end}}
    {{- end}}
    {{- end}}
    {{- range tags 0 9000}}
    <url>
        <loc>{{.Url}}</loc>
        <mobile:mobile type="pc,mobile"/>
        <lastmod>{{date .Updated "day"}}</lastmod>
        <changefreq>daily</changefreq>
        <priority>0.9</priority>
    </url>
    {{- end}}
    {{- range sitemap 40000}}
    <url>
        <loc>{{.Url}}</loc>
        <mobile:mobile type="pc,mobile"/>
        <lastmod>{{date .Updated "day"}}</lastmod>
        <changefreq>daily</changefreq>
        <priority>0.8</priority>
    </url>
    {{- end}}
</urlset>