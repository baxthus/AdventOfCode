package main

import (
	"crypto/md5"
	"encoding/hex"
	"strconv"
)

func findPassword(doorID string) string {
	password := ""
	index := 0

	for len(password) < 8 {
		toHash := doorID + strconv.Itoa(index)
		hash := md5.Sum([]byte(toHash))
		hashResult := hex.EncodeToString(hash[:])

		if hashResult[:5] == "00000" {
			password += string(hashResult[5])
		}

		index++
	}

	return password
}

func findPassword2(doorID string) string {
	password := make([]byte, 8)
	for i := range password {
		password[i] = '_'
	}
	index := 0
	filledPositions := 0

	for filledPositions < 8 {
		toHash := doorID + strconv.Itoa(index)
		hash := md5.Sum([]byte(toHash))
		hashResult := hex.EncodeToString(hash[:])

		if hashResult[:5] == "00000" {
			position := hashResult[5]
			if position >= '0' && position <= '7' {
				pos := int(position - '0')
				if password[pos] == '_' {
					password[pos] = hashResult[6]
					filledPositions++
				}
			}
		}

		index++
	}

	return string(password)
}

func main() {
	doorID := "ojvtpuvg"

	println("Part 1:", findPassword(doorID))
	println("Part 2:", findPassword2(doorID))
}
