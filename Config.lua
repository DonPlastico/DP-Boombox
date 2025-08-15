Config = Config or {}
Config.framework = 'qbcore' -- (qbcore/esx/custom)
Config.useItem = true
Config.fixSpeakersCommand = "fixSpeakers" -- Si los altavoces no se cargan, utilice este comando para recargar todos los altavoces.
Config.itemName = 'speaker' -- Necesitas tener este item creado en tu configuración o base de datos
Config.timeZone = "Europe/Madrid" -- IMPORTANTE establecer en qué zona horaria se encuentra su servidor
Config.KeyAccessUi = 38 -- E
Config.KeyDeleteSpeaker = 194 -- BACKSPACE
Config.KeyToMove = 311 -- K
Config.KeyToPlaceSpeaker = 191 -- ENTER
Config.KeyToChangeAnim = 311 -- K

Config.useCustomTextUI = 'dp' -- Opciones: 'qbcore', 'esx', 'dp', 'default', 'custom'
Config.useQBCoreNotify = true -- true para usar QBCore Notify, false para usar el de por defecto de gta5.

Config.Translations = {
    notEnoughDistance = 'Deberías reservar un poco más de distancia del otro hablante cercano.',
    helpNotify = 'Presiona ~INPUT_CONTEXT~ para acceder al altavoz, ~INPUT_FRONTEND_RRIGHT~ para eliminarlo o ~INPUT_REPLAY_SHOWHOTKEY~ para mantener presionado el boombox.',
    libraryLabel = 'Tu biblioteca',
    newPlaylistLabel = 'Crear nueva lista de reproducción',
    importPlaylistLabel = 'Importar una lista de reproducción existente',
    newPlaylist = 'Nueva lista de reproducción',
    playlistName = 'Nombre de la lista de reproducción',
    addSong = 'Agregar canción',
    deletePlaylist = 'Eliminar lista de reproducción',
    unkown = 'Desconocida',
    titleFirstMessage = "¿Aún no tienes una lista de reproducción?",
    secondFirstMessage = "Crear una lista de reproducción",
    holdingBoombox = 'Presiona ~INPUT_FRONTEND_RDOWN~ para colocar el altavoz.',
    tooFarWhileMoving = 'Te has alejado demasiado mientras movías el altavoz. Acción cancelada.',
    dejarBoombox = 'Dejarlo en el suelo',
    cambiarAnimacion = 'Cambiar animación'
}
