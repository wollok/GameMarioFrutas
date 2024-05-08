import wollok.game.*

object tanteador{
	method text() = "Maximo Puntaje " + mario.mejorPuntaje()
	method position() = game.at(game.width()/2,game.height()-2)
	method agarrado() {
	  // no escribo nada, porque no pasa nada cuando lo "agarra" mario	
	}
} 
object fondo {
    var position = game.origin().down(1)
    
    method image() = "auto.jpg"
    method desplazamiento() {
    	position = position.left(1)
    	if (position.x() < -20)
    	   position = position.right(40)
    }
	method empezarADesplazarse() {
		game.onTick(300,"fondo",{self.desplazamiento()})
	}
	method position() = position 
    
  
}

object juego {
	const frutas = [mani, manzana,papa,tomate]
	method iniciar() {
		game.cellSize(32)
		game.height(20)
		game.width(40)
		game.title("Juego")
		game.addVisual(fondo)
//		game.addVisualCharacter(mario)
		game.addVisual(mario)
		self.agregarFrutas()
		self.configurarAcciones()
		game.start()
	}
	
	method agregarFrutas() {
		game.addVisual(tanteador)
		frutas.forEach{x=> 
			game.addVisual(x)} 
		game.onTick(5000,"moverse",{tomate.relocalizar()})
	}
	method configurarAcciones() {
		game.onCollideDo(mario, {algo=>algo.agarrado()})
		keyboard.enter().onPressDo({game.say(mario,"Tengo " + mario.puntos())})
		keyboard.up().onPressDo({mario.subir()}) 
		keyboard.down().onPressDo({mario.bajar()}) 
		keyboard.left().onPressDo({mario.retroceder()}) 
		keyboard.right().onPressDo({mario.avanzar()})
		keyboard.space().onPressDo({mario.saltar()})
		fondo.empezarADesplazarse() 
		 
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
		game.removeTickEvent("fondo")
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
    var avanza = true
	method image() = 
	   "mario-" 
	   + (if (avanza) "derecha" else "izquierda" )
	   + ".png"
	
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
	method subir() {
		position = position.up(1) 
	}
	method bajar() {
		position = position.down(1) 
	}
	method avanzar() {
		position = position.right(3) 
		avanza = true
	}
	method retroceder() {
		position = position.left(2) 
		avanza = false
	}
	method saltar(){
		self.subir()
		game.schedule(100,{self.subir()})
		game.schedule(1000,{self.bajar() self.bajar()})
	}
	method mejorPuntaje() = 
	  if (inventario.isEmpty()) 
	    0 
	  else
	    (inventario.max{x=>x.puntos()}).puntos()
	
}

object mani {
	
	method position() = papa.position().right(2)
	
	method agarrado(){
		mario.agarrar(self)
		game.say(self,"Maní Oculto Desbloqueado")
	}
	method puntos() = 100
}
