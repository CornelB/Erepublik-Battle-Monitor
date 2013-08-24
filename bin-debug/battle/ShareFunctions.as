package battle
{
	public class ShareFunctions
	{
		public function ShareFunctions()
		{
		}
		public function skroc(s:String, doIlu:int):String
		{
			if(s.length<=doIlu){
				return s
				
			}
			else{
				var l1:String=s.substr(0,doIlu);
				if(l1.charAt(l1.length-1)==' ')l1=s.substr(0,doIlu-1);
				return l1+'.';
				
			}
		}
		public function spaceChange(s:String):String
		{
			if(s.search(' ')!=-1)return (spaceChange(s.replace(' ','-')))
			else return s;
			
		}
	}
}