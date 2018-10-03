/*
Language: Kodi
Author: Team Kodi
Description: language definition for Kodi log files
Category: config
*/

function(hljs) {
  return {
    aliases: ['kodi.log'],
    case_insensitive: false,
    keywords: 'DEBUG INFO NOTICE WARNING',
    contains: [
      {
        className: 'deletion',
        begin: '(ERROR|SEVERE|FATAL):',
        end: '.',
        excludeEnd: true,
      },
      {
        className: 'meta',
        begin: 'LOG_LEVEL_(NONE|NORMAL|DEBUG(_FREEMEM)?)',
        end: '.',
        excludeEnd: true,
      },
      {
        className: 'title',
        begin: '(?:s(?:cr(?:eensaver|ipt)|ervice|kin)|i(?:magedecoder|nputstream)|p(?:eripheral|lugin|vr)|re(?:pository|source)|(?:webinterfac|gam)e|v(?:isualization|fs)|audio(?:de|en)coder|metadata|kodi|xbmc)(\\.[a-zA-Z0-9_-]+)+',
        end: '.',
        excludeEnd: true,
        relevance: 0,
      },
    ],
  }
}
