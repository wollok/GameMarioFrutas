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
		game.onTick(5000,"moverse",{tomate.relocalizar()})
	}
	method configurarAcciones() {
		game.onCollideDo(mario, {algo=>algo.agarrado()})
		keyboard.enter().onPressDo({game.say(mario,"Tengo " + mario.puntos())}) 
	}
}


object manzana {

	method image() = "manzana.png"
	
	method position() = game.center()
	
	method agarrado() {
		game.removeVisual(self)
		mario.agarrar(self)
		//mario.sumaPuntos(10)
	}
	method puntos() = 10
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
		game.schedule(2000,{game.stop()})
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
	method puntos() = -5
	
	method agarrado() {
		//mario.sumaPuntos(-5)
		self.relocalizar()
		mario.agarrar(self)
	}
	method relocalizar() {
		position = self.validar(position
		   .right(desplazamientos.anyOne())
		   .up(desplazamientos.anyOne()))
		   
		   
 
	}
	method validar(posicion) {
		const nuevoY = posicion.y().min(game.height()-1).max(0) 
		const nuevoX = posicion.x().min(game.width()-1).max(0)
		return game.at(nuevoX,nuevoY) 
	}
}


object mario{
	const inventario = []
	var position = game.origin()
//	var puntos = 0
	method image() = "mario.png"
	
	method position() = position
	method position(nueva) {
		position = nueva
	}
	
	method agarrar(cosa){
		inventario.add(cosa)
	}
	
//	method sumaPuntos(cant){
//		puntos = puntos + cant
//	}
	method puntos() = inventario.sum({x=>x.puntos()})
}