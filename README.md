# MGSC
En el archivo `MMO.swf` (el bootstrap del juego) hay varias funciones que se irán añadiendo a medida que se encuentre funcionalidad.
Las siguientes librerías se pueden encontrar descompilando el archivo `MMO.swf`, devolviendo un archivo `.fla` con código `.as` (ActionScript 3).
## MMO
La clase inicial, que carga un gran número de librerías del paquete `com.qb9`, dentro de ese paquete se encuentran otras librerías, que podrían considerarse las principales.

Su funcionamiento se entiende en:
1. **MMO()**
	Define el objeto que va a almacenar el overlay y las opciones; Las opciones se entienden como archivos json auxiliares que se cargan en segundo plano, los cuales son: `settings.json`, `locale.json` y `gameplay.json`
2. **added()**
	Llamada mediante un eventListener, esta función se invoca cuando el `MMO.swf` es agregado al `MMOLoader.swf`, esta función solo se encarga de invocar `setup()`
3. **setup()**
	Remueve el eventListener de `ADDED_TO_STAGE`, procede a llamar otro listener para agregar textos y modificar la calidad visual de la escena, cambia el estado a `LOADING_CONFIGURATION` e invoca a `setupSettings()`
4. **setupSettings()**
	Usa la constante `SETTINGS_URI` para llamar una clase `LoadFile` junto al `baseUrl`, almacenándola temporalmente en `_loc1_`, se procede a definir un `eventListener` al `_loc1_`, especificando que cuando esté listo llame a la función `loadLocales()`
5. **loadLocales()**
	Esta carga los archivos `gameplay.json` y `locale.json` pero con la clase `GaturroLoadFile`, ya que estos van a ser usados dentro del mundo MMO
	Se abre una secuencia la cual es para unir las configuraciónes `mergeSettings()`
6. **mergeSettings()**
	Copia en la clase Settings el objeto `gameplay` y `settings` y procede a cargar el archivo `preloading.json`
7. **loadLastModifiedNews()**
	Carga el archivo `lastModified.txt` e invoca la clase `loadLanguages()`
8. **loadLanguages()**
	Carga lenguajes
9. **continueSetup()**
	Invoca los métodos `connect()` y `loadSounds()`
10. **connect()**
	Verifica que el user agent no sea `"[No ExternalInterface]"` y que el directorio esté disponible *(directorio es ref. a la lista de servidores [servers.json])*
11. **showServers()**
	Cambia el estado a `DIRECTORY`, genera una nueva lista de servidores `ServersScreen()` y añade 3 listeners
	- `ERROR`: Omite la selección de servidores `skipServerElection()` e intenta enviarlo a un servidor default
	- `READY`: Invoca `whenServersAreReady()` que a su vez llama a `disposeLoading()`, que remueve la pantalla de carga
	- `CHOSE`: salta a chooseServer(), remueve la pantalla de servidores, carga en la variable `_loc2_` el objeto de `connection` dentro de `settings.json`, le agrega `address`, `port` y `servername` al objeto `connection`, define la variable `this.serverName` e inicia la conexión
12. **initiateConnection()**
	Cambia el estado a `CONNECTING`, define un objeto `connectionSettings` del archivo `servers.json`, a su vez almacena la dirección en `serverAddress` y crea un nuevo objeto con la clase `DefaultNetworkManager()`  (Véase [DefaultNetworkManager.as])

En el [siguiente archivo](CONNECTION.md) se hace una explicación más extensa sobre el proceso de conexión desde el cliente al servidor por medio de sockets TCP
### Gaturro
Se encarga en gran parte del manejo de los sprites y salas dentro del cliente, tiene algunas utilidades para el manejo de strings/arrays, contando reporte de errores
#### com.qb9.gaturro.view.screens.ServersScreen
Recibe los servidores disponibles desde el archivo `server.json`
#### com.qb9.gaturro.util.errors
Envía los errores capturados, el string lo saca de `locales.json`
#### com.qb9.gaturro.util.errors.PhpErrorLog
Hace reportes de errores al endpoint `https://mundogaturro.com/logger.php`
# Assets
Los assets contienen subclases, las cuáles se encargan del comportamiento de los objetos dentro del juego, desde las prendas, hasta objetos del hogar.
## ClothMamboAsset
En el `frame1()` deben ir una variable `clothes` la cuál debe ir asignada con las siguientes opciones:

```json
{
    "accesories": "filename.itemid",
    "hats": "filename.itemid",
    "foot": "filename.itemid",
    "arm": "filename.itemid",
    "cloth": "filename.itemid",
    "neck": "filename.itemid",
    "leg": "filename.itemid",
    "hairs": "filename.itemid",
    "transport": "filename.transportid" /*must be TransportOnMamboAsset*/
}
```
## ConsumableMamboAsset
Se pueden especificar acciones bajo la variable/objeto `adds`

```actionscript
	adds.effect (string)
	adds.action (string)
	questItem (bool)
```
* Effect:
```actionscript
 "type.hexColor"
```
	Valores de `type`:
	-	glow
	
* Action:
```actionscript
 "animation.swfFile.id"
```
	Valores de `animation`:
	-	percussion
	-	guitar
	-	flag

# Observaciones
- La lista de servidores cuando se retorna, devuelve un valor inferior al real, si el puerto en servers.json es 4098, en el bootstrap se le agrega 1, lo que hace que 4099 sea el valor real **(véase [MMO.as])**
- Token Basic: gaturro:gatoprepro **(véase [PhpErrorLog.as])**
- com.qb9.mines.network.MinesServer | bootstrap conexión
- com.qb9.gaturro : serviceAccessKey:"0PN5J17HBGZHT7JJ3X82" || securityRequestKey:"ABDpIUDlKDABDpIU"
- com.qb9.gaturro.net.requests.SecureMamboRequest // Aparentemente envia las peticiones de manera "segura" con un hash
- private const securityKey:String = "YEDpIUWlKSIBBwIK"; 

[MMO.as]: https://github.com/nikitacontreras/mgsc/blob/main/MMO.as#L507 "MMO.as"
[PhpErrorLog.as]: https://github.com/nikitacontreras/mgsc/blob/main/com/qb9/gaturro/util/errors/PhpErrorLog.as#L85 "PhpErrorLog.as"
[DefaultNetworkManager.as]: https://github.com/nikitacontreras/mgsc/blob/main/com/qb9/mambo/net/manager/DefaultNetworkManager.as "DefaultNetworkManager.as"
