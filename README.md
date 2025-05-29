# proyecto translate loop
Gracias al vibe coding con un simple ChatGPT, he completado este proyecto.

Es una página web que permite una traducción CONTÍNUA de un idioma a otro. 
En su configuración más sencilla solo necesitas alojar una página HTML con su CSS en un servidor HTTPS. Debe ser https para poder abrir el micrófono.

El funcionamiento es sencillo:
- eliges el idioma origen y destino.
- pulsas "Probar voz" para que el navegador admita reproducir sonido.
- pulsas "Probar red" para comprobar que el traductor está disponible.
- pulsas "Iniciar" y empiezas a hablar. Desde ese momento la página escucha el micrófono, la transcripción aparece a la izquierda y la traducción a la derecha.
- las cajas de texto hacen scroll automático.
- la traducción se reproduce por los altavoces. Mientras ocurre esto, la página sigue escuchando, transcribiendo, traduciendo, etc.
- pulsas "Detener" para dejar de usar el micrófono y terminar todo el proceso.
- pulsas "Ocultar texto original" para dejar de ver la transcripción. Pulsas de nuevo para volver a verlo.
- pulsas "Reproduciendo texto" para dejar de escuchar la traducción. Pulsas de nuevo para volver a escuchar.
- pulsas "Ocultar controles" para dejar más sitio a las cajas de texto ocultando los botones. Pulsas de nuevo para mostrar los botones.
- las alternativas de transcripción mejoran un poco la conversión de audio a texto. A cambio de más consumo de CPU en el navegador y más retardo.
  
Como se está utilizando el dispositivo del usuario, en la misma sala puede haber varias personas a la vez traduciendo al mismo idioma o distintos.

Técnicamente, en el navegador ocurren tres procesos: la escucha, la transcripción de audio a texto y la reproducción del texto traducido. La traducción es un servicio externo.

CONFIGURACIÓN BÁSICA
Alojar los ficheros "tl-lingva.html" y "estilos-tl.css" en un servidor HTTPS. Aceptando los permisos que solicite el navegador y, si lingva.ml está disponible, estaremos listos para empezar.

CONFIGURACIÓN AVANZADA
Si no queremos depender de un servicio de traducción externo, podemos utilizar Libre Translate. 
Lo más sencillo es arrancarlo en un docker. He puesto un script en la carpeta "libre-translate". 
Lo arranca con los idiomas inglés, español, chino tradicional y alemán. Externamente está escuchando en el puerto 3011.

Los ficheros que debemos alojar en un servidor HTTPS son "tl-local.html" y "estilos-tl.css". En el fichero HTML hay que cambiar la localización del servicio de traducción. Son las líneas:
  window.open('https:///srv-libre-translate', '_blank');
  const url = 'https://srv-libre-translate/translate';

Ahora tenemos dos opciones:

- el servidor HTTPS y el servidor Libre Translate están en nuestra LAN.

La sustitución de "srv-libre-translate" no puede ser directamente la IP del docker porque es un servicio HTTP y el tráfico debe ser HTTPS. Nos hace falta un servicio proxy. Lo podemos hacer con un docker como muestro en la carpeta "proxy", que abre un HTTPS en el puerto 3013 con la configuración que indico para nginx.

Por ejemplo, si el docker de Libre Translate está en 192.168.10.201 y el docker del proxy están en 192.168.10.202, en la configuración del proxy debe aparecer:

  proxy_pass http://192.168.10.201:3011/translate;

Y en el fichero HTML pondremos:

  window.open('https:///192.168.10.202:3013', '_blank');
  const url = 'https://192.168.10.202:3013/api/translate';

- el servidor HTTPS está en Internet y el servidor Libre Translate está en nuestra LAN.

En este caso, podemos abrir un túnel SSH como muestro en la carpeta "tunnel". En el ejemplo, si nuestra IP pública de salida a Internet es 1.2.3.4 y nuestro router redirige el puerto SSH a una máquina Linux, sería:

  ssh -f -N -4 -L localhost:3011:192.168.10.201:3011 usr-tunnel@1.2.3.4

Hay que añadir ese endpoint al apache con una cierta protección sustituyendo "midomain.com" por el nuestro:

  <Location /lt>
    ProxyPass http://localhost:3011/
    ProxyPassReverse http://localhost:3011/
        
    SetEnvIf Referer "^https://midomain.com" allow_referer
    Require env allow_referer
  </Location>

Ahora podemos modificar el fichero HTML:

     window.open('https:///midomain.com/lt', '_blank');
     const url = 'https://midomain.com/lt/translate';

En esta configuración seguramente no funcione el botón "Probar red". Pero probablemente la traducción funcionará bien.

Seguramente ambas configuraciones pueden mejorarse; pero cuento lo que a mí me ha funcionado. 8-)

Si necesitáis ayuda con docker, servidores HTTPS, proxy, túneles SSH... ChatGPT o cualquier otro LLM.

Cualquier sugerencia de mejora será bien recibida.

Saludos.
