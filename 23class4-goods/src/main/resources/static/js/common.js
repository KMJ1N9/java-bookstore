function _change() {
    $("#vCode").attr("src", "/goods/user/createVerifycode?" + new Date().getTime());
}