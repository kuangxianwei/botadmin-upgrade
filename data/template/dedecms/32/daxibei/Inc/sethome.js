//����ie,firefox
//�����ղ�
function addCookie()
{
 if (document.all)
    {
       window.external.addFavorite('http://www.yztyy.com','�������ҩҵ���޹�˾');
    }
    else if (window.sidebar)
    {
       window.sidebar.addPanel('�������ҩҵ���޹�˾', 'http://www.yztyy.com', "");
 }
}
//��Ϊ��ҳ
function setHomepage()
{
 if (document.all)
    {
        document.body.style.behavior='url(#default#homepage)';
  document.body.setHomePage('http://www.yztyy.com');
 
    }
    else if (window.sidebar)
    {
    if(window.netscape)
    {
         try
   {  
            netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");  
         }  
         catch (e)  
         {  
    alert( "�ò�����������ܾ�����������øù��ܣ����ڵ�ַ�������� about:config,Ȼ���� signed.applets.codebase_principal_support ֵ��Ϊtrue" );  
         }
    } 
    var prefs = Components.classes['@mozilla.org/preferences-service;1'].getService(Components. interfaces.nsIPrefBranch);
    prefs.setCharPref('browser.startup.homepage','http://www.yztyy.com');
 }
}