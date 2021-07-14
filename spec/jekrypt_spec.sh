# shellcheck shell=bash

Include jekrypt
Describe "Get File Key"
  Example "returns the right FileKey"
    When call decryptedFileToKey "2020-01-01-test.md"
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
Describe "Encrypt file"
  Example "Encrypts as expected"
    When call encryptFile "spec/expected/decrypted/2020-01-01-test.md" "spec/actual/encrypted" "test"
    RESULT="$(cat spec/actual/encrypted/2020-01-01-7bb114137b)"
    The contents of file "spec/expected/encrypted/2020-01-01-7bb114137b" should equal "$RESULT"
  End
End
