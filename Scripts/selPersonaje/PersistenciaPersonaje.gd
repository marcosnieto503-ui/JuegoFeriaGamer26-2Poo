extends Node

const CARPETA := "res://personajes/"
const ARCHIVO_GENERO := {"Hombre": "hombre", "Mujer": "mujer", "Otro": "otro"}
const ARCHIVO_PIEL := {"Blanco": "blanco", "Negro": "negro"}
const ARCHIVO_ACCESORIO := {
	"Cabello corto": "corto", "Cabello largo": "largo", "Trenzas": "trenzas",
	"Moño": "mono", "Corbata": "corbata", "Sombrero": "sombrero",
}

var personaje := {"genero": "", "piel": "", "accesorio": ""}

func ruta_reaccion(reaccion: String) -> String:
	return CARPETA + reaccion + "_" \
		+ ARCHIVO_GENERO[personaje["genero"]] + "_" \
		+ ARCHIVO_PIEL[personaje["piel"]] + "_" \
		+ ARCHIVO_ACCESORIO[personaje["accesorio"]] + ".png"
