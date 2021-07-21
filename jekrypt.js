(async function () {
  // Cases
  // - has ?pass or has ?masterpass => set it in LS
  // then
  // - has normal password in LS => decrypt text
  // - has only masterpassword in LS => decrypt password => set LS password => decrypt text

  const urlParams = new URLSearchParams(window.location.search);

  if (urlParams.get("masterpassword")) {
    localStorage.setItem("masterpassword", urlParams.get("masterpassword"))
  }

  if (document.querySelectorAll(".encrypted").length == 0) {
    return;
  }

  const pathname = filename
  if (urlParams.get("pass")) {
    localStorage.setItem(pathname, urlParams.get("pass"))
  }

  if (!localStorage.getItem(pathname) && localStorage.getItem("masterpassword")) {
    const key = await decrypt(passwords[pathname], localStorage.getItem("masterpassword"))

    localStorage.setItem(pathname, key.trim())

  }

  const key = localStorage.getItem(pathname)

  if (key) {
    document.querySelectorAll(".encrypted").forEach(
      element => decrypt(element.textContent.trim(), key)
        .then(result => element.innerHTML = result)
        .then(() => {
          if (!urlParams.get("pass")) {
            history.pushState({}, "", "?pass=" + key)
          }
        })
    )
  } else {
    document.querySelectorAll(".encrypted").forEach(element => element.innerHTML = "MISSING KEY: " + element.innerHTML)
  }


  async function decrypt(str, key) {
    const encryptedMessage = await openpgp.readMessage({
      armoredMessage: atob(str)
    });
    const { data: decrypted } = await openpgp.decrypt({
      message: encryptedMessage,
      passwords: [key],
    });
    return decrypted
  }


})()
