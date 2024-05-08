import wollok.game.*

object juego {
	method iniciar() {
		game.cellSize(32)
		game.height(20)
		game.width(40)
		game.title("Juego")
		game.addVisual(mario)
		self.agregarFrutas()
		game.start()
	}
	
	method agregarFrutas() {
		game.addVisual(manzana) 
		game.addVisual(papa) 
		game.addVisual(tomate) 
	}
}


object manzana {

	method image() = "manzana.png"
	
	method position() = game.center()
}


object papa{
	method image() = "papa.png"
	
	method position() = game.at(2,8)
}

object tomate{
	var position = game.at(5,5)
	method image() = "tomate.png"
	
	method position() = position
	
	method position(nueva){
		position = nueva
	}
}


object mario{
	var position = game.origin()
	
	method image() = "mario.png"
	
	method position() = position
	method position(nueva) {
		position = nueva
	}
}