package errors

func PanicErrorDBConnection(err error) {
	if err != nil {
		panic("Failed to connect database.")
	}
}

func PanicError(err error) {
	if err != nil {
		panic(err.Error())
	}
}