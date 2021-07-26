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
    The path "spec/actual/encrypted/2020-01-01-7bb114137b.md" should be exist
    # ignore shellcheck warning. Shellspec stop here because return is 1.
    GREP_RESULT="$(echo "$(grep -c "The" < "spec/actual/encrypted/2020-01-01-7bb114137b.md")")"
    The variable GREP_RESULT should equal 0
  End
  Example "Encrypts and Decrypts as expected"
    When call decryptFile "spec/actual/encrypted/2020-01-01-7bb114137b.md" "spec/actual/decrypted" "test"
    The path "spec/actual/decrypted/2020-01-01-test.md" should be exist
    ACTUAL=$(cat "spec/actual/decrypted/2020-01-01-test.md")
    EXPECTED=$(cat "spec/expected/decrypted/2020-01-01-test.md")
    The variable ACTUAL should eq "$EXPECTED"
  End
  Example "Results should be equal"
    ACTUAL=$(cat "spec/actual/decrypted/2020-01-01-test.md")
    EXPECTED=$(cat "spec/expected/decrypted/2020-01-01-test.md")
    The variable ACTUAL should eq "$EXPECTED"
  End
End
Describe "Encrypt/Decrypt second file"
  Example "Encrypts generate at least a file"
    When call encryptFile "spec/expected/decrypted/2020-01-02-some-other-test.md" "spec/actual/encrypted" "test"
    The path "spec/actual/encrypted/2020-01-02-a9796b5920.md" should be exist
  End
  Example "Encrypts and Decrypts as expected"
    When call decryptFile "spec/actual/encrypted/2020-01-02-a9796b5920.md" "spec/actual/decrypted" "test"
    The path "spec/actual/decrypted/2020-01-02-some-other-test.md" should be exist
  End
  Example "Results should be equal"
    ACTUAL=$(cat "spec/actual/decrypted/2020-01-02-some-other-test.md")
    EXPECTED=$(cat "spec/expected/decrypted/2020-01-02-some-other-test.md")
    The variable ACTUAL should eq "$EXPECTED"
  End
End
