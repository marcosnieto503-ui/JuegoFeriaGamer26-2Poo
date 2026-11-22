extends Node

const CARPETA := "res://Assets/selPersonaje/personajes/"

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
func ruta_reaccion(reaccion: String = "feliz") -> String:
	var ruta: String = "%s%s_%s_%s_%s.png" % [
		CARPETA,
		reaccion,
		GENEROS.get(genero, "hombre"),
		PIELES.get(piel, "blanco"),
		ACCESORIOS.get(accesorio, "corto")
	]
	return ruta

# Devuelve directamente la textura lista para asignar a un Sprite2D o TextureRect
func obtener_reaccion(reaccion: String = "feliz") -> Texture2D:
	var ruta: String = ruta_reaccion(reaccion)
	if ResourceLoader.exists(ruta):
		return load(ruta)
	push_warning("PersistenciaPersonaje: No se encontró la imagen: " + ruta)
	return null
