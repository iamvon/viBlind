package models

type(
	ArticleModel struct {
		ID           int    `json:"id"`
		Date         string `json:"date"`
		Topic        string `json:"topic"`
		Title        string `json:"title"`
		Introduction string `json:"introduction"`
		Content      string `json:"content"`
		Summarize 	 string `json:"summarize"`
		Url          string `json:"url"`
		HashUrl      string `json:"hash_url"`
	}
)
