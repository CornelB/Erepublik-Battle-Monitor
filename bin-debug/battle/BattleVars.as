package battle
{
	import mx.collections.ArrayCollection;

	public class BattleVars
	{
		public var battleId:int;
		public var attacker:String;
		public var defender:String;
		public var attackerID:int;
		public var defenderID:int;
		public var userID:int;
		public var region:String;
		public var isResistance:String;
		public var bsurl:String;
		public var email:String;
		public var pass:String;
		
		
		public var attackerDomin:Array;
		public var defenderDomin:Array;
		public var arrackerPercent:Array;
		public var defenderPercent:Array;
		
		public var attackerDominOld:Array;
		public var defenderDominOld:Array;
	//	public var attackerPercentOld:Array;
		public var defenderPercentOld:Array;
		
		public var odIluOdliczacOdswierzenia:int;
		public var licznikOdswierzen:int;
		public var czyMoznaOdswierzac:Boolean;
		public var ileSekundTrwaJuzMini:int;
		
		public var battleHerosAreHidden:Boolean;


		
		
		public function BattleVars(battleId:int,odIluOdliczacOdswierzenia:int,bsurl:String,userID:int, email:String, pass:String)
		{
			this.odIluOdliczacOdswierzenia=odIluOdliczacOdswierzenia;
			this.ileSekundTrwaJuzMini=0;
			this.licznikOdswierzen=1;
			this.czyMoznaOdswierzac=true;
			this.battleId=battleId;
			this.bsurl=bsurl;
			this.battleHerosAreHidden=true;
			this.userID=userID;
			this.email=email;
			this.pass=pass;
			
			this.attackerDomin=new Array(9999,9999,9999,9999);//wymagane do ustawienia czasu na poczatku
			this.defenderDomin=new Array(9999,9999,9999,9999);
		//	this.attackerPercent=new Array(0,0,0,0);
			this.defenderPercent=new Array(0,0,0,0);
			
			this.attackerDominOld=new Array(-201,-201,-201,-201);//żeby na początku nie było animacji
			this.defenderDominOld=new Array(-201,-201,-201,-201);
		//	this.attackerPercentOld=new Array(0,0,0,0);
			this.defenderPercentOld=new Array(0,0,0,0);
		}
	}
}