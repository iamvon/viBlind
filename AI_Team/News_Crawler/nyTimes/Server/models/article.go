package models

type(
	ArticleModel struct {
		ID        		uint   	`json:"id"`
		Date 			string  `json:"date"`
		Topic 			string 	`json:"topic"`
		Title			string 	`json:"title"`
		Introduction	string	`json:"introduction"`
		Content			string	`json:"content"`
		Url				string	`json:"url"`
	}
)
