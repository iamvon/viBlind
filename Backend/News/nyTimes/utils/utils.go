package utils

import "strconv"

func StringToInt(stringNumber string) (int) {
	intNumber, _ := strconv.Atoi(stringNumber)
	return intNumber
}
