extends Node

const CARPETA := "res://MENUS/Assets/selPersonaje/personajes/"

enum REACCIONESDISPONIBLES {
	FELIZ,
	ENOJADO,
	SORPRENDIDO,
	NEUTRAL
}

var Dict_REACCIONES:Dictionary[PersistenciaPersonaje.REACCIONESDISPONIBLES,String] ={
	PersistenciaPersonaje.REACCIONESDISPONIBLES.FELIZ:"feliz",
	PersistenciaPersonaje.REACCIONESDISPONIBLES.ENOJADO:"enojado",
	PersistenciaPersonaje.REACCIONESDISPONIBLES.SORPRENDIDO:"sorprendido",
	PersistenciaPersonaje.REACCIONESDISPONIBLES.NEUTRAL:"serio"
}

# Mapeo a los nombres de tus archivos .png
const GENEROS := {"Hombre": "hombre", "Mujer": "mujer", "Otro": "otro"}
const PIELES := {"Blanco": "blanco", "Negro": "negro"}
const ACCESORIOS := {
	"Cabello corto": "corto", "Cabello largo": "largo", "Trenzas": "trenzas",
	"Moño": "mono", "Corbata": "corbata", "Sombrero": "sombrero",
}

var genero := ""
var piel := ""
var accesorio := ""

# Función para guardar las 3 elecciones globales
func guardar(nuevo_genero: String, nueva_piel: String, nuevo_accesorio: String) -> void:
	genero = nuevo_genero
	piel = nueva_piel
	accesorio = nuevo_accesorio

# Devuelve la ruta en texto de la imagen del personaje según la emoción
func ruta_reaccion(reaccion:PersistenciaPersonaje.REACCIONESDISPONIBLES) -> String:
	var ruta: String = "%s%s_%s_%s_%s.png" % [
		CARPETA,
		ACCESORIOS.get(accesorio),
		GENEROS.get(genero),
		PIELES.get(piel),
		Dict_REACCIONES.get(reaccion),
	]
	print("\nRUTA ARCIVO: ",ruta,"\n")
	return ruta

# Devuelve directamente la textura lista para asignar a un Sprite2D o TextureRect
func obtener_reaccion(reaccion:PersistenciaPersonaje.REACCIONESDISPONIBLES = PersistenciaPersonaje.REACCIONESDISPONIBLES.NEUTRAL) -> Texture2D:
	var ruta: String = ruta_reaccion(reaccion)
	if ResourceLoader.exists(ruta):
		return load(ruta)
	push_warning("PersistenciaPersonaje: No se encontró la imagen: " + ruta)
	return null


func DEBUGobtenerDatos() -> String:
	return "DATOS PLAYER: %s , %s , %s" % [genero ,piel ,accesorio]
