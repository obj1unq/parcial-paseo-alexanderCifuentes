
//NOTA 9 (nueve)
//Test: 4 verdes, 2 fallan, no hizo el resto
//1) B+, si bien hay algunas fallas, la búsqueda del template method quedó muy bueno
//2) MB
//3) B+
//4) MB
//5) MB
//6) B+
//7) B+
//8) MB

//-------------------------------------------------------------------------------------------------------------------------------
//TODO: Quedo PrendaPEsada como padre de PrendaLiviana y PrendaPar. Si bien podría no estar mal, queda
//semánticamente incorrecto, ya que estaría afirmando que tanto una PrendaLiviana como una PrendaPar
//es una PrendaPesada. 
class PrendaPesada{
	var property talle = null
	var property desgaste = 0
	var abrigo = 0
	
	method comodidad(ninio){ 
		return self.puntosPorTalleIgual(ninio) -self.nivelDeDesgaste()-self.puntosPorEdad(ninio)		 	
	}
	
	method puntosPorTalleIgual(ninio){
		if(ninio.talle()== talle){
			return 8
		}else{
		 	return 0
		 }
		 //TODO: más simple: return if(ninio.talle()== talle) 8 else 0
	}
	
	//TODO: Esto por requerimiento solo es valido para prenda par
	method puntosPorEdad(ninio){
		if(ninio.edad()< 4){
			return 1
		}else{
			return 0
		}
	}
	
	method nivelDeDesgaste(){
		if (desgaste>3){
			return 3
		}else{
		
		return desgaste
		
		}
		//TODO: más simple: return desgaste.min(3). 
		//Igualmente no está del todo bien que esto esté acá. 
		//ya que la ropa tiene un desgaste que puede ser mucho más que 3
		//El tema es que para la comodidad aporta como máximo 3.
		//Lo mejor es tratar ambas cosas por separado: un mensaje para saber
		//el desgaste, otro para saber cuanto se descuenta por desgaste
	}

	
	method agregarDesgaste(){
		desgaste +=1
	}
	
	method abrigo(){
		return abrigo
	}
	
	method aumentarDesgaste(num){
		desgaste +=num
	}


	
	method promedioCalidad(ninio){
		return self.abrigo()+self.comodidad(ninio)
	}
	 
	
	
}

//------------------------------------------------------------------------------------------------------------------------------
class PrendaPar inherits PrendaPesada{
	var property izquierdo
	var property derecho
	
	
	//TODO Acá estás perdiendo el máximo de 3 para calcular la comodidad
	override method nivelDeDesgaste(){
		return (izquierdo.desgaste() + derecho.desgaste())/2
	}
	
	method agregarDerecho(unDerecho){
		derecho = unDerecho
	}
	
	override method agregarDesgaste(){
		izquierdo.agregarDesgaste()
		derecho.agregarDesgaste()
	}
	
	method derecho(){
		return derecho
	}
	method izquierdo(){
		return izquierdo
	}
	
	
	
	method checkTalle(prenda){
		if(self.talle() != prenda.talle()){
			self.error("No se pueden intercambiar prendas de diferentes talles")
		}
	}
	
	
	method intercambiar(prenda){
		self.checkTalle(prenda)
		var prendaAuxiliar = self.derecho()
		self.agregarDerecho(prenda.derecho())
		prenda.agregarDerecho(prendaAuxiliar)
	}
	
	//TODO: Faltó el nivel de abrigo
}

//---------------------------------------------------------------------------------------------------------------------------

class Izquierdo {
	var property desgaste = 0
	var property abrigo = 0
	
	method agregarDesgaste(){
		desgaste += 0.8
	}
}
//---------------------------------------------------------------------------------------------------------------------------
class Derecho{
	var property desgaste = 0
	var property abrigo = 0
	
	method agregarDesgaste(){
		desgaste +=1.2
	}
}
//---------------------------------------------------------------------------------------------------------------------------


//-------------------------------------------------------------------------------------------------------------------------------

//Objetos usados para los talles
object xs {
}

object s {
}
object m {
	
}
object l{
	
}
object xl{
	
}




class Familia{
	var ninios = #{}
	
	method puedePasear(){
		return ninios.all({ninio=> ninio.estaListoParaIrDePaseo()})
	}
	
	method infaltables(){
		//TODO: Hacer un asSet para que sea un conjunto
		return ninios.map({ninio=> ninio.prendaDeMaximaCalidad()})
	}
	
	//TODO: El criterio de saver si un nene es chiquito o no debería estar en ninio
	//ya que se usa en más de un lugar y quedó duplicado
	method chiquitos(){
		return ninios.filter({ninio=>ninio.edad()<4})
	}
	method checkPuedeSalirDePaseo(){
		if(!self.puedePasear()){
			self.error("La familia no puede salir de paseo")
		}
	}
	
	method pasear(){
		self.checkPuedeSalirDePaseo()
		ninios.forEach({ninio=>ninio.agregarDesgasteASusPrendas()})
	}
}

//------------------------------------------------------------------------------------------------------------------------------
class Ninio{
	var talle
	var property edad
	var prendas = #{}
	
	method talle(){
		return talle
	}
	
	method agregarDesgasteASusPrendas(){
		prendas.forEach({prenda=> prenda.agregarDesgaste()})
	}
	
	method talle(unTalle){
		talle = unTalle
	}
	method cantidadDePrendas(){
		return prendas.size()
	}
	method nivelAbrigoSuperiorA(num){
		return prendas.any({prenda=> prenda.abrigo()>=num})
	}
	
	method promedioDeCalidadDeLasPrendas(){
										//TODO: El mensaje que se manda a la prenda deberia ser calidad 
		return prendas.sum({prenda=> prenda.promedioCalidad(self)})/self.cantidadDePrendas()
	}
	
	method estaListoParaIrDePaseo(){
		return  self.nivelAbrigoSuperiorA(3) && self.cantidadDePrendas()>=self.cantidadPrendasNecesarias()
		 && self.promedioDeCalidadDeLasPrendas()>=8
	}
	
	method cantidadPrendasNecesarias(){
		return 5
	}
	
	method prendaDeMaximaCalidad(){
		return prendas.max({prenda=> prenda.promedioCalidad(self)})
	}
	
	
}

//----------------------------------------------------------------------------------------------------------------------------

class NinioProblematico inherits Ninio{
	var juguete
	
	override method cantidadPrendasNecesarias(){
		return 4
	}
	
	method tieneEdadAcordeParaElJuguete(){
		return self.edad() >= juguete.edadMinimaRecomendad() && self.edad() <= juguete.edadMaximaRecomendada()
	}
	
	override method estaListoParaIrDePaseo(){
		return super() && self.tieneEdadAcordeParaElJuguete()
	}
}


//-----------------------------------------------------------------------------------------------------------------------------
class PrendaLiviana inherits PrendaPesada{
	
	override method comodidad(ninio){
		return super(ninio)+2
	}
	
	override method abrigo (){
		return   abrigoPrendasLivianas.abrigo()
	}
}
//---------------------------------------------------------------------------------------------------------------------------
object abrigoPrendasLivianas{
	var property abrigo = 1
}
//---------------------------------------------------------------------------------------------------------------------------



class Juguete{
	var property edadMinimaRecomendad
	var property edadMaximaRecomendada
}



	




 