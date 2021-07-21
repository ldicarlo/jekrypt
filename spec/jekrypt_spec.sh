# shellcheck shell=bash

Include jekrypt
Describe "Get File Key"
  Example "returns the right FileKey"
    When call hashFilename "2020-01-01-test.md"
    The output should eq "2020-01-01-7bb114137b"
  End
End
Describe "Get Front Matter"
  Example "Returns the right text"
    TEXT=$(cat spec/test-file.md)
    FRONTMATTER="$(cat spec/test-file-front-matter)"
    When call frontMatter "$TEXT"
    The output should eq "$FRONTMATTER"
  End
End
Describe "Encrypt/Decrypt file"
  Example "Encrypts generate at least a file"
    When call encryptFile "spec/expected/decrypted/2020-01-01-test.md" "spec/actual/encrypted" "test"
    The path "spec/actual/encrypted/2020-01-01-7bb114137b" should be exist
  End
  Example "Encrypts and Decrypts as expected"
    When call decryptFile "spec/actual/encrypted/2020-01-01-7bb114137b" "spec/actual/decrypted" "test"
    The path "spec/actual/decrypted/2020-01-01-test.md" should be exist
  End
  Example "Results should be equal"
    ACTUAL=$(cat "spec/actual/decrypted/2020-01-01-test.md")
    EXPECTED=$(cat "spec/expected/decrypted/2020-01-01-test.md")
    The variable ACTUAL should eq "$EXPECTED"
  End
End
