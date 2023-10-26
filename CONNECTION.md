# Mecanismo de conexión al servidor (Mambo) por medio de los helpers (Mines)
En este documento se va a hacer un recorrido lógico de los métodos y funciones a profundidad, desde cómo se inicia la conexión, como se trata, qué se envía y recibe y por último, cómo finaliza.

## MMO()
La conexión empieza desde el archivo MMO, creando un DefaultNetworkManager

## com.qb9.mambo.net.manager.DefaultNetworkManager()
Dentro del DefaultNetworkManager, se crea un objeto `MinesServer` llamado `mines`, el cuál se encarga de la conexión mediante socket al servidor; Se agrega un listener con `MinesEvent.MESSAGE = "MinesMessage"` y se envía a la función `this.handleMamboEvent()`

En un foreach se agregan los listeners definidos en la constante `MINES_EVENTS`, siendo este una array que contiene los eventos de conexión establecidos en `MinesEvent`
En el constructor se crea un `new MinesServer()`, con los parámetros `(false, param1)`, `false` sería si la conexión está en modo debug (`this.debug`), y `param1` es el timeout de la conexión.



## com.qb9.mines.network.MinesServer()
Después de haber definido los valores `isDebug:Boolean` y `timeout:int`, se inicia la conexión con `this.init()`
Dentro del init() se inician los eventos con `initEvents()`, creando el socket y agregando un `EventListener` por cada uno de los posibles resultados del socket.

- `Event.CLOSE (this.CloseHandler())`: Se envía un evento `MinesEvent.CONNECTION_LOST = "MinesLost"`
- `Event.CONNECT (this.connectHandler())`: Se envía un evento `MinesEvent.CONNECT = "MinesConnect"`
- `IOErrorEvent.IO_ERROR y SecurityErrorEvent.SECURITY_ERROR (this.failedConnectHandler())`: Se envía un evento `MinesEvent.CONNECT`, el `param2` de ese MinesEvent en `false`
- `ProgressEvent.SOCKET_DATA (this.socketDataHandler())`: Recibe los bytes de la conexión en un objeto `ProgressEvent` y empieza a manipularlo:
  
  - Se verifica que no haya un mensaje definido pendiente o bytes recibidos existentes (`this.message`)
  - Se leen los bytes y se almacenan en la variable temporal `_loc2_`
  - Si la variable temporal no es igual al `HEADER_TYPE` definido en la clase `com.qb9.mines.network.Message` (Siendo este 3), retorna nada, si no, define `this.message` como un nuevo objeto `Message`
  - Se verifica que `this.message` necesite un payload, si los bytes disponibles del socket son inferiores a 4, se agarra el valor del socket como int `this.socket.readInt()` y se define como `payload` del `this.message`
  - Se envía el socket a un lector `this.message.read(this.socket)`
  - Se comprueba que el mensaje esté completo `this.message.isComplete()`, en caso de que lo esté, se procesa `this.processMessage(this.message)`

Cada uno de esos eventos usa el método `this.dispatch(param1, param2, param3, param4)`, el cuál con la herencia de `EventDispatcher` envía eventos con un objeto `MinesEvent`, el cuál contiene el valor de la desconexión por medio de las constantes definidas de `MinesEvent`, un valor `boolean` indicando el `success`, el errorcode a enviar (`param3`), y un MObject si es necesario (`param4`)

Se comienza a procesar el mensaje recibido por parte del servidor con el método `this.processMessage(data:*)`, primero se convierte el `data` a Mobject y se obtiene el string `"type"` en la variable `type`, se busca en la constante `RESPONSE_TYPE_MAPPING:Object` con el tipo, si está disponible

En el caso predeterminado, se despacha el valor que se haya recibido de la constante por medio del `dispatch(valorConstante, response.getBoolean("result"), response.getString("errorCode"), response.getMobject("mobject"))`

### com.qb9.mambo.net.manager.DefaultNetworkManager()

Dentro del `handleMamboEvent(param1:MinesEvent)` se obtiene el `mObject` del `param1`, se obtienen 3 valores, un string `"messageId"`, un string `"type"` y un boolean`"forceProcess"`

Estos se envían al método (`handleEvent(type, mobject, mobject.hasBoolean("success"), mobject.getString("errorCode" or "errorMessage"))`), generando un `NetworkManagerEvent()` y despachándolo

