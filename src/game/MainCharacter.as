package game 
{
	import game.inventory.Inventory;
	import game.inventory.Tool;
	import game.objects.AirTank;
	import game.objects.FuelTank;
	import game.objects.Tank;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Jayson
	 */
	public class MainCharacter extends FlxSprite 
	{
		[Embed(source = '../../assets/spritesheets/astronauta.png')] public static var playerImg:Class;
		[Embed(source = '../../assets/sfx/hurt.mp3')] public static var hurtSfx:Class;
		
		//public var controller: ICharacterController;
		public var life: Number;
		private var dying: Boolean;
		private var gameCore: GameCore;
		private var counter: Number;
		
		public var lastVelocity: FlxPoint;
		
		private var leftBtnPressed: Boolean;
		private var rightBtnPressed: Boolean;
		private var upBtnPressed: Boolean;
		private var downBtnPressed: Boolean;
		
		private var deathBlank: FlxSprite;
		
		//Our emmiter
		private var theEmitter:FlxEmitter;

		//Our white pixel (This is to prevent creating 200 new pixels all to a new variable each loop)
		private var whitePixel:FlxParticle;
		
		private var inventory: Inventory;
		
		public var fuel: Number;
		public var airTime: Number;
		public const AIRTIME: Number = 300;
		public const FUEL: Number = 15;
		public var lastBreath: Number;
		public const LASTBREATH: Number = 10;
		
		public var impulse: Boolean;
		
		private var currentlyTile: FlxPoint;
		private var posToCalcTile: FlxPoint;
		
		private var upRightTile: Number;
		private var upUpRightTile: Number;
		private var upLeftTile: Number;
		private var upUpLeftTile: Number;
		private var upTile: Number;
		private var downRightTile: Number;
		private var downLeftTile: Number;
		private var downTile: Number;
		private var leftTile: Number;
		private var rightTile: Number;
		
		private var currentlyTileNum: Number;
		
		private var turning: Boolean;
		private var fillingAirTank:Boolean;
		private var oldVelocity:FlxPoint;
		private var fillingFuelTank:Boolean;
		private var fillingTank: Boolean;
		
		private var _suitDamage: Number;
		
		
		public function MainCharacter(gameCore: GameCore, inventory: Inventory, fuel: Number = FUEL) {
			super();
			
			loadGraphic(playerImg, true, true, 39, 61);
			
			drag.x = 0;
			drag.y = 0;
			maxVelocity.x = 1000000000;
			maxVelocity.y = 1000000000;
			life = 3;
			airTime = AIRTIME;
			this.fuel = fuel;
			lastBreath = LASTBREATH;
			counter = 1;
			
			this.inventory = inventory;
			
			theEmitter = new FlxEmitter(this.x + 20, this.y + 30, 50);
			theEmitter.lifespan = 0.5;
			//Now by default the emitter is going to have some properties set on it and can be used immediately
			//but we're going to change a few things.

			//Let's also make our pixels rebound off surfaces
			//theEmitter.bounce = .8;

			//Now let's add the emitter to the state.
			gameCore.gameLayer.add(theEmitter);
			
			//Now it's almost ready to use, but first we need to give it some pixels to spit out!
			//Lets fill the emitter with some white pixels
			for (var i:int = 0; i < theEmitter.maxSize/2; i++) {
				whitePixel = new FlxParticle();
				whitePixel.makeGraphic(2, 2, 0xFFFFFFFF);
				whitePixel.visible = false; //Make sure the particle doesn't show up at (0, 0)
				theEmitter.add(whitePixel);
				whitePixel = new FlxParticle();
				whitePixel.makeGraphic(1, 1, 0xFFFFFFFF);
				whitePixel.visible = false;
				theEmitter.add(whitePixel);
			}
			
			//width = 20;
			//height = 35;
			//offset.x = 15;
			//offset.y = 12;
			
			lastVelocity = new FlxPoint();
			
			posToCalcTile = new FlxPoint();
			currentlyTile = new FlxPoint();
			oldVelocity = new FlxPoint();
			
			suitDamage = 0;
			
			this.gameCore = gameCore;
			
			FlxG.watch(acceleration, "x");
			FlxG.watch(velocity, "x");
		}
		
		override public function update():void {
			super.update();
			
			if (airTime >= 0)
				if (suitDamage >= 100)
					airTime -= FlxG.elapsed * 5;
				else
					airTime -= FlxG.elapsed;
			else {
				lastBreath -= FlxG.elapsed;
				
				if (lastBreath > 5)
					gameCore.blinkRed(0.05);
				else if (lastBreath > 2)
					gameCore.blinkRed(0.1);
				else
					gameCore.blinkRed(0.2);
			}
			
			if (lastBreath <= 0)
				kill();
			
			if (!isTouching(ANY))
				dying = false;
				
			lastVelocity.x = velocity.x;
			lastVelocity.y = velocity.y;
			
			if (FlxG.keys.justPressed("SPACE")) {
				FlxG.overlap(this, gameCore.inventoryItemsList, function (obj1: FlxObject, obj2: FlxObject):void 
				{
					gameCore.gameLayer.remove(obj2);
					inventory.add(obj2);
				});
			}
			
			if (FlxG.keys.SPACE) {
				FlxG.overlap(this, gameCore.airTanksList, fillAirTank);
				FlxG.overlap(this, gameCore.fuelTanksList, fillFuelTank);
			}
			
			if (FlxG.keys.justReleased("SPACE") || fillingTank && ((airTime >= AIRTIME) ||
				(fillingFuelTank && fuel >= FUEL))) {
				if (airTime >= AIRTIME)
					airTime = AIRTIME;
					
				if (fuel >= FUEL)
					fuel = FUEL;
				
				fillingTank = false;
				velocity = oldVelocity;
			}
			
			posToCalcTile.x = x + width/2;
			posToCalcTile.y = y + height/2;
			
			currentlyTile.x = Math.floor(posToCalcTile.x / Constants.TILE_SIZE);
			currentlyTile.y = Math.floor(posToCalcTile.y / Constants.TILE_SIZE);
			
			currentlyTileNum = gameCore.level.getTile(currentlyTile.x, currentlyTile.y);
			upRightTile = gameCore.level.getTile(currentlyTile.x + 1, currentlyTile.y - 1);
			upUpRightTile = gameCore.level.getTile(currentlyTile.x + 1, currentlyTile.y - 2);
			upLeftTile = gameCore.level.getTile(currentlyTile.x - 1, currentlyTile.y - 1);
			upUpLeftTile = gameCore.level.getTile(currentlyTile.x - 1, currentlyTile.y - 2);
			upTile = gameCore.level.getTile(currentlyTile.x, currentlyTile.y - 1);
			downRightTile = gameCore.level.getTile(currentlyTile.x + 1, currentlyTile.y + 1);
			downLeftTile = gameCore.level.getTile(currentlyTile.x - 1, currentlyTile.y + 1);
			downTile = gameCore.level.getTile(currentlyTile.x, currentlyTile.y + 1);
			rightTile = gameCore.level.getTile(currentlyTile.x + 1, currentlyTile.y);
			leftTile = gameCore.level.getTile(currentlyTile.x - 1, currentlyTile.y);
			
			if (!fillingTank) {
				if((FlxG.keys.A || FlxG.keys.LEFT) && fuel > 0 && !impulse && acceleration.x == 0 && acceleration.y == 0) {
					fuel -= FlxG.elapsed;
					
					theEmitter.x = this.x + 20 + (velocity.x / 30);
					theEmitter.y = this.y + 30 + (velocity.y / 30);
					
					facing = FlxObject.LEFT;
					velocity.x -= 10;
					leftBtnPressed = true;
					theEmitter.setXSpeed(100 + this.velocity.x, 250 + this.velocity.x);
					theEmitter.setYSpeed(-25 + this.velocity.y, 25 + this.velocity.y);
					theEmitter.emitParticle();
					theEmitter.emitParticle();
					theEmitter.emitParticle();
				}
				if((FlxG.keys.D || FlxG.keys.RIGHT) && fuel > 0 && !impulse && acceleration.x == 0 && acceleration.y == 0) {
					fuel -= FlxG.elapsed;
					
					theEmitter.x = this.x + 20 + (velocity.x / 30);
					theEmitter.y = this.y + 30 + (velocity.y / 30);
					
					facing = FlxObject.RIGHT;
					velocity.x += 10;
					rightBtnPressed = true;
					theEmitter.setXSpeed(-100 + this.velocity.x, -250 + this.velocity.x);
					theEmitter.setYSpeed(-25 + this.velocity.y, 25 + this.velocity.y);
					theEmitter.emitParticle();
					theEmitter.emitParticle();
					theEmitter.emitParticle();
				}
				if ((FlxG.keys.W || FlxG.keys.UP) && fuel > 0 && !impulse && acceleration.x == 0 && acceleration.y == 0) {
					fuel -= FlxG.elapsed;
					
					theEmitter.x = this.x + 20 + (velocity.x / 30);
					theEmitter.y = this.y + 30 + (velocity.y / 30);
					
					velocity.y -= 10;
					upBtnPressed = true;
					theEmitter.setYSpeed(100 + this.velocity.y, 250 + this.velocity.y);
					theEmitter.setXSpeed(-25 + this.velocity.x, 25 + this.velocity.x);
					theEmitter.emitParticle();
					theEmitter.emitParticle();
					theEmitter.emitParticle();
				}
				if ((FlxG.keys.S || FlxG.keys.DOWN) && fuel > 0 && !impulse && acceleration.x == 0 && acceleration.y == 0) {
					fuel -= FlxG.elapsed;
					
					theEmitter.x = this.x + 20 + (velocity.x / 30);
					theEmitter.y = this.y + 30 + (velocity.y / 30);
					
					velocity.y += 10;
					downBtnPressed = true;
					theEmitter.setYSpeed(-100 + this.velocity.y, -250 + this.velocity.y);
					theEmitter.setXSpeed(-25 + this.velocity.x, 25 + this.velocity.x);
					theEmitter.emitParticle();
					theEmitter.emitParticle();
					theEmitter.emitParticle();
				}
				
				//Walking on the right
				if (acceleration.x > 0) {
					if ((FlxG.keys.W || FlxG.keys.UP)) {
						velocity.y = -50;
					} else if ((FlxG.keys.S || FlxG.keys.DOWN)) {
						velocity.y = 50;
					} else if (FlxG.keys.D || FlxG.keys.RIGHT) {
						if (upRightTile == 0) {
							velocity.y = -50;
							turning = true;
						} else if (downRightTile == 0) {
							velocity.y = 50;
							turning = true;
						}
					} else if ((FlxG.keys.justPressed("A") || FlxG.keys.justPressed("LEFT"))) {
						acceleration.x = 0;
						velocity.x = -50;
						velocity.y = 0;
						impulse = true;
					}
				} else if (turning && impulse && (FlxG.keys.D || FlxG.keys.RIGHT)) {
					if (upRightTile == 0) {
						turning = false;
						velocity.x = 50;
						velocity.y = 50;
					} else if (downRightTile == 0) {
						turning = false;
						velocity.x = 50;
						velocity.y = -50;
					}
				}
				
				//Walking on the left
				if (acceleration.x < 0) {
					if ((FlxG.keys.W || FlxG.keys.UP)) {
						velocity.y = -50;
					} else if ((FlxG.keys.S || FlxG.keys.DOWN)) {
						velocity.y = 50;
					} else if (FlxG.keys.A || FlxG.keys.LEFT) {
						if (upLeftTile == 0) {
							velocity.y = -50;
							turning = true;
						} else if (downLeftTile == 0) {
							velocity.y = 50;
							turning = true;
						}
					} else if ((FlxG.keys.justPressed("D") || FlxG.keys.justPressed("RIGHT"))) {
						acceleration.x = 0;
						velocity.x = 50;
						velocity.y = 0;
						impulse = true;
					}
				} else if (turning && impulse && (FlxG.keys.A || FlxG.keys.LEFT)) {
					if (upLeftTile == 0) {
						turning = false;
						velocity.x = -50;
						velocity.y = 50;
					} else if (downLeftTile == 0) {
						turning = false;
						velocity.x = -50;
						velocity.y = -50;
					}
				}
				
				//Walking on down
				if (acceleration.y > 0) {
					if ((FlxG.keys.A || FlxG.keys.LEFT)) {
						velocity.x = -50;
					} else if ((FlxG.keys.D || FlxG.keys.RIGHT)) {
						velocity.x = 50;
					} else if (FlxG.keys.S || FlxG.keys.DOWN) {
						if (downLeftTile == 0) {
							velocity.x = -50;
							turning = true;
						} else if (downRightTile == 0) {
							velocity.x = 50;
							turning = true;
						}
					} else if ((FlxG.keys.justPressed("W") || FlxG.keys.justPressed("UP"))) {
						acceleration.y = 0;
						velocity.x = 0;
						velocity.y = -50;
						impulse = true;
					}
				} else if (turning && impulse && (FlxG.keys.S || FlxG.keys.DOWN)) {
					if (downLeftTile == 0) {
						turning = false;
						velocity.y = 50;
						velocity.x = 50;
					} else if (downRightTile == 0) {
						turning = false;
						velocity.y = 50;
						velocity.x = -50;
					}
				}
				
				//Walking on up
				if (acceleration.y < 0) {
					if ((FlxG.keys.A || FlxG.keys.LEFT)) {
						velocity.x = -50;
					} else if ((FlxG.keys.D || FlxG.keys.RIGHT)) {
						velocity.x = 50;
					} else if (FlxG.keys.W || FlxG.keys.UP) {
						if (upLeftTile == 0) {
							velocity.x = -50;
							turning = true;
						} else if (upRightTile == 0) {
							velocity.x = 50;
							turning = true;
						}
					} else if ((FlxG.keys.justPressed("S") || FlxG.keys.justPressed("DOWN"))) {
						acceleration.y = 0;
						velocity.y = 50;
						velocity.x = 0;
						impulse = true;
					}
				} else if (turning && impulse && (FlxG.keys.W || FlxG.keys.UP)) {
					if (upLeftTile == 0) {
						turning = false;
						velocity.y = -50;
						velocity.x = 50;
					} else if (upRightTile == 0) {
						turning = false;
						velocity.y = -50;
						velocity.x = -50;
					}
				}
			}
			
			if (FlxG.keys.justReleased("A") || FlxG.keys.justReleased("LEFT")){
				leftBtnPressed = impulse = turning = false;
			}
			if(FlxG.keys.justReleased("D") || FlxG.keys.justReleased("RIGHT")){
				rightBtnPressed = impulse = turning = false;
			}
			if (FlxG.keys.justReleased("W") || FlxG.keys.justReleased("UP")){
				upBtnPressed = impulse = turning = false;
			}
			if (FlxG.keys.justReleased("S") || FlxG.keys.justReleased("DOWN")){
				downBtnPressed = impulse = turning = false;
			}
		}
		
		private function fillTank(tank: Tank):void {
			if (FlxG.keys.justPressed("SPACE")) {
				oldVelocity = new FlxPoint(velocity.x, velocity.y);
				velocity.x = 0;
				velocity.y = 0;
			}
			
			fillingTank = true;
			
			if (tank.volume > 0) {
				tank.volume -= 1;
				
				if (tank is AirTank) {
					airTime += 1;
				} else if (tank is FuelTank) {
					fuel += 1;
				}
			} else {
				fillingTank = false;
				velocity = oldVelocity;
			}
		}
		
		private function fillAirTank(obj1: FlxObject, obj2: FlxObject):void {
			if (airTime < AIRTIME && obj2 is AirTank) {
				lastBreath = LASTBREATH;
				gameCore.resetBlinkRed();
				fillTank(Tank(obj2));
			} else {
				fillingTank = false;
				velocity = oldVelocity;
			}
		}
		
		private function fillFuelTank(obj1: FlxObject, obj2: FlxObject):void {
			if (fuel < FUEL && obj2 is FuelTank) {
				fillTank(Tank(obj2));
			} else {
				fillingTank = false;
				velocity = oldVelocity;
			}
		}
		
		override public function kill():void {
			FlxG.resetState();
			
			velocity.x = 0;
			velocity.y = 0;
			
			airTime = 50;
			life = 3;
			gameCore.resetHud();
		}
		
		public function causeHurt():void {
			if (!dying) {
				FlxG.play(hurtSfx);
				
				dying = true;
				life -= 1;
				this.flicker(1);
				gameCore.life = life;
				velocity.x = -200;
				velocity.y = -200;
				
				if (life <= 0) {
					kill();
				}
			}
			else if (counter > 0) {
				counter -= FlxG.elapsed;
			}
			else if (counter <= 0) {
				counter = 1;
				dying = false;
			}
		}
		
		public function get suitDamage():Number 
		{
			return _suitDamage;
		}
		
		public function set suitDamage(value:Number):void 
		{
			_suitDamage = value;
			if (_suitDamage > 100)
				_suitDamage = 100;
			else if (_suitDamage < 0)
				_suitDamage = 0;
		}
		
	}

}