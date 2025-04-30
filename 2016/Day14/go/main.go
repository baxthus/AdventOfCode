package main

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"strconv"
	"strings"
)

func md5Hash(input string) string {
	hasher := md5.New()
	hasher.Write([]byte(input))
	return hex.EncodeToString(hasher.Sum(nil))
}

func stretchedMd5Hash(input string) string {
	hash := md5Hash(input)
	for range 2016 {
		hash = md5Hash(hash)
	}
	return hash
}

func hasTriplet(hash string) (bool, byte) {
	for i := range len(hash) - 2 {
		if hash[i] == hash[i+1] && hash[i] == hash[i+2] {
			return true, hash[i]
		}
	}
	return false, 0
}

func hasQuintuplet(hash string, char byte) bool {
	quintuplet := strings.Repeat(string(char), 5)
	return strings.Contains(hash, quintuplet)
}

type hashFunction func(string) string

func findKeyIndex(salt string, hashFunc hashFunction) int {
	index := 0
	keysFound := 0
	hashes := make(map[int]string)

	getHash := func(idx int) string {
		if hash, ok := hashes[idx]; ok {
			return hash
		}
		computedHash := hashFunc(salt + strconv.Itoa(idx))
		hashes[idx] = computedHash
		return computedHash
	}

	for keysFound < 64 {
		currentHash := getHash(index)
		foundTriplet, tripletChar := hasTriplet(currentHash)

		if foundTriplet {
			for i := index + 1; i <= index+1000; i++ {
				nextHash := getHash(i)
				if hasQuintuplet(nextHash, tripletChar) {
					keysFound++
					break
				}
			}
		}

		index++
	}

	return index - 1
}

func main() {
	salt := "zpqevtbw"

	fmt.Printf("Index of the 64th key: %d\n", findKeyIndex(salt, md5Hash))
	fmt.Printf("Index of the 64th key with stretched hash: %d\n", findKeyIndex(salt, stretchedMd5Hash))
}
