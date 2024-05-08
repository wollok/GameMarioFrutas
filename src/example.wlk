import wollok.game.*

object juego {
	method iniciar() {
		game.cellSize(32)
		game.height(20)
		game.width(40)
		game.title("Juego")
		game.addVisualCharacter(mario)
		self.agregarFrutas()
		self.configurarAcciones()
		game.start()
	}
	
	method agregarFrutas() {
		game.addVisual(manzana) 
		game.addVisual(papa) 
		game.addVisual(tomate) 
	}
	method configurarAcciones() {
		game.onCollideDo(mario, {algo=>algo.agarrado()})
		keyboard.enter().onPressDo{game.say(mario,"Tengo " + mario.puntos() )   } 
	}
}


object manzana {

	method image() = "manzana.png"
	
	method position() = game.center()
	
	method agarrado() {
		game.removeVisual(self)
		mario.sumaPuntos(10)
	}
}


object gameOver {
	method text() = "GAME OVER"
	method position() = game.center() 
}

object papa{
	method image() = "papa.png"
	
	method position() = game.at(2,8)
	
	method agarrado() {
		game.removeVisual(mario)
		game.addVisual(gameOver)
	}
}

object tomate{
	const desplazamientos = [-1,5,7,-3,0]
	var position = game.at(5,5)
	method image() = "tomate.png"
	
	method position() = position
	
	method position(nueva){
		position = nueva
	}
	
	method agarrado() {
		mario.sumaPuntos(-5)
		self.relocalizar()
	}
	method relocalizar() {
		position = position
		   .right(desplazamientos.anyOne())
		   .up(desplazamientos.anyOne()) 
	}
}


object mario{
	var position = game.origin()
	var puntos = 0
	method image() = "mario.png"
	
	method position() = position
	method position(nueva) {
		position = nueva
	}
	
	method sumaPuntos(cant){
		puntos = puntos + cant
	}
	method puntos() = puntos
}