function md5(input: string): string {
  const hasher = new Bun.CryptoHasher("md5");
  hasher.update(input);
  return hasher.digest("hex");
}

function stretchedMd5(input: string): string {
  let hash = md5(input);
  for (let i = 0; i < 2016; i++) {
    hash = md5(hash);
  }
  return hash;
}

const tripletRegex = /(.)\1\1/;

function findTripletChar(hash: string): string | null {
  const match = hash.match(tripletRegex);
  return match?.[1]!;
}

function hasQuintuplet(hash: string, char: string): boolean {
  const quintuplet = char.repeat(5);
  return hash.includes(quintuplet);
}

function find64thKeyIndex(
  salt: string,
  hashFunction: (input: string) => string,
): number {
  let index = 0;
  let keysFound = 0;
  const hashes: string[] = [];

  const getHash = (idx: number): string =>
    hashes[idx] ?? (hashes[idx] = hashFunction(salt + idx));

  while (keysFound < 64) {
    const currentHash = getHash(index);
    const tripletChar = findTripletChar(currentHash);

    if (tripletChar) {
      for (let i = index + 1; i <= index + 1000; i++) {
        const nextHash = getHash(i);
        if (hasQuintuplet(nextHash, tripletChar)) {
          keysFound++;
          break;
        }
      }
    }

    index++;
  }

  return index - 1;
}

const salt = "zpqevtbw";

console.log(`Index of the 64th key: ${find64thKeyIndex(salt, md5)}`);
console.log(
  `Index of the 64th key (stretched): ${find64thKeyIndex(salt, stretchedMd5)}`,
);
