<p align="center">
<h1 align="center">🎵 [FiveM] ¡SISTEMA DE ALTAVOZ PARA FIVEM! | Música In-Game con Diseño Avanzado inspirado en SPOTIFY | DP-Boombox 🎵</h1>

<img width="960" height="auto" align="center" alt="DP-Animations Logo" src="https://i.imgur.com/zQS9GoF.png" />

</p>

<div align="center">

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![FiveM](https://img.shields.io/badge/FiveM-Script-important)](https://fivem.net/)
[![QBCore](https://img.shields.io/badge/QBCore-Framework-success)](<[https://qbcore-framework.github.io/qb-docs/](https://github.com/qbcore-framework)>)

</div>

<h2 align="center"> 📝 Descripción General</h2>
¡Lleva la experiencia musical de Spotify, SoundCloud y YouTube directamente a tu servidor FiveM! Este script único, desarrollado a mano con inspiración en la interfaz de Spotify, ofrece funciones personalizadas y un diseño pulido para una inmersión total. ¡Totalmente terminado y listo para usar!

<details>
<summary><h2 align="center">¿Qué es y qué hace?</h2></summary>
- Permite a los jugadores reproducir música in-game con una interfaz similar a Spotify.<br>
- Incluye funciones de sincronización para que varios jugadores puedan escuchar la misma música.<br>
- Proporciona control de volumen y navegación de pistas desde el menú.<br>
- El sistema de sonido tiene un medidor de distancias, haciendo que la música suene más suave a medida que te alejas del altavoz.<br>

</details>
<details>
<summary><h2 align="center">¿Cómo funciona?</h2></summary>
- Usa la interfaz NUI para mostrar un menú de mascotas en la tienda.<br>
- Permite gestionar el estado de la mascota (salud, hambre, sed, higiene, cariño).<br>
- Las mascotas se pueden comprar en la tienda y liberar de forma permanente.<br>

</details>
<details>
<summary><h2 align="center">¿Qué te permite?</h2></summary>
✅ Interfaz estilo Spotify, SoundCloud y YouTube 🎧.<br>
✅ Reproduce música in-game 🎶.<br>
✅ Medidor de distancias para las canciones.<br>
✅ Listas compartibles.<br>
✅ Sincronización con otros jugadores 👥.<br>
✅ Control de volumen y pistas directamente desde el menú.<br>
✅ Configurador avanzado ⚙️.<br>
✅ Integración con DP-Admin para gestión de logs.<br>
✅ Optimizado para servidores RP 🎭: Sin lags y compatible con otros recursos.<br>

</details>
<br><br>
<h2 align="center"> 🚀 Instalación</h2>

<details>
<summary><h2 align="center">Requisitos previos</h2></summary>
- Servidor FiveM con cualquier framework instalado (ESX/QBCORE/CUSTOM/STANDALONE).<br>
- MySQL configurado. (oxmysql)<br>

</details>
<details>
<summary><h2 align="center">Pasos de instalación</h2></summary>
1. **Descargar el script** desde el repositorio oficial.<br>
2. **Colocar la carpeta** en tu servidor con el nombre exacto DP-Boombox.<br>
   - ⚠️ El nombre debe ser exactamente este para evitar problemas.<br>
3. **Configuración de la Base de Datos**.<br>
Abre el archivo Insert.sql.<br>
Copia y pega el contenido en tu base de datos MySQL y ejecútalo para crear la tabla de mascotas/pets.
(Asegúrate de que tu servidor tenga acceso a la base de datos configurada para mysql-async / ghmattimysql / oxmysql.).<br>
4. **DAñadir el item speaker** a tu inventario/framework. Para QB-Core, copia y pega el siguiente código en tu archivo qb-core/shared/items.lua:<br>
speaker = {
    name = "speaker",
    label = "Altavoz",
    weight = 0,
    type = "item",
    image = "speaker.png",
    unique = false,
    useable = true,
    shouldClose = true,
    combinable = nil,
    description = "Dispositivo de salida de audio que convierte señales eléctricas en ondas sonoras audibles. Es un componente fundamental en cualquier sistema de reproducción de sonido. En pocas palabras, es un ALTAVOZ BLUETOOTH de toda la vida..."
},

<img width="300" height="auto" align="center" alt="speaker" src="speaker.png" />

</details>
<br><br>
<h2 align="center"> ⚙️ Dependencias</h2>
El script es compatible con todos los frameworks (ESX/QBCORE/CUSTOM/STANDALONE). No requiere dependencias adicionales a parte del oxmysql.
<details>
<summary><h2 align="center"> 📦 Requisitos del Sistema</h2></summary>

| Recurso                                                                                       | Descripción         | Enlace                                                   |
| --------------------------------------------------------------------------------------------- | ------------------- | -------------------------------------------------------- |
| <img src="https://placehold.co/20x20/555555/FFFFFF?text=QB" alt="QB"> qb-core                 | Framework principal | [🔗 GitHub](https://github.com/qbcore-framework/qb-core) |
| <img src="https://placehold.co/20x20/555555/FFFFFF?text=DP" alt="DP"> PD-TextUI (recomendado) | Text UI avanzado    | [🔗 GitHub]()                                            |

</details>
<br><br>
<h2 align="center">🛠️ Configuración</h2>
El archivo config.lua te permite personalizar el script según tus necesidades.

<details>
<summary><h2 align="center">⚙️ Mostrar configuración</h2></summary>

<h3>config.lua</h3>
<img width="400" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="https://i.imgur.com/XNDr6BY.png" />

| Archivo        | Función Principal                                                                                        |
| -------------- | -------------------------------------------------------------------------------------------------------- |
| **config.lua** | Define las configuraciones principales del script, como los comandos, las notificaciones y los permisos. |

</details>
<br><br>
<h2 align="center"> 🖼️ Vistas Previas</h2>
Aquí tienes una lista de las vistas previas de tu script.

<details>
<p align="center">
<summary><h2 align="center">Interfaz de Usuario NUI</h2></summary>

<img width="250" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="![alt text](image.png)" />

<img width="250" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="![alt text](image-1.png)" />

<img width="350" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="![alt text](image-2.png)" />

<img width="350" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="![alt text](image-3.png)" />

<img width="350" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="![alt text](image-4.png)" />

</p>
</details>
<details>
<p align="center">
<summary><h2 align="center">SQL</h2></summary>

<img width="250" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="https://i.imgur.com/3KzPPwN.png" />

<img width="250" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="https://i.imgur.com/XNZB0V3.png" />

<img width="250" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="https://i.imgur.com/K6aXl2N.png" />

<img width="250" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="https://i.imgur.com/Nn4Gjcy.png" />

<img width="250" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="https://i.imgur.com/X9pknPD.png" />

</p>
</details>
<details>
<p align="center">
<summary><h2 align="center">Video Demostrativo</h2></summary>

<a href="https://youtu.be/Z9MF6zxNCag">
<img width="959" height="auto" alt="Video Demostrativo" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="https://i.imgur.com/zQS9GoF.png" />
</a>

</p>
</details>
<br><br>
<h2 align="center"> 🔮 Posibles Mejoras Futuras</h2>
El DP-Boombox es un script robusto, pero siempre hay espacio para mejoras y nuevas funcionalidades.

<details>
<summary><h2 align="center">🚧 En desarrollo</h2></summary>

| IDEA                            | EXPLICACIÓN                                                                        |
| ------------------------------- | ---------------------------------------------------------------------------------- |
| **Soporte de más servicios**    | Integrar más servicios de música en línea además de Spotify, SoundCloud y YouTube. |
| **Nuevas funciones de control** | Añadir más opciones de control, como el aleatorio y la repetición.                 |

</details>

Autor: DP-Scripts<br>
Versión: 1.0.0
