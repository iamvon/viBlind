package Rss

var RssURL = []string{
	"http://rss.nytimes.com/services/xml/rss/nyt/Africa.xml",
	"http://rss.nytimes.com/services/xml/rss/nyt/Americas.xml",
	"http://rss.nytimes.com/services/xml/rss/nyt/AsiaPacific.xml",
	"http://rss.nytimes.com/services/xml/rss/nyt/Europe.xml",
	"http://rss.nytimes.com/services/xml/rss/nyt/MiddleEast.xml",
}

var RssToCategory = map[string]string{
	RssURL[0]: "Africa",
	RssURL[1]: "Americas",
	RssURL[2]: "Asia Pacific",
	RssURL[3]: "Europe",
	RssURL[4]: "Middle East",
}
