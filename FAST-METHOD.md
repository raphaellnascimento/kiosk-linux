# MÉTODO RÁPIDO - 20 Minutos Total!

Ao invés de construir do zero (2+ horas), customizamos uma ISO Debian Live pronta!

## Tempo Total: ~20 Minutos

- Download Debian Live: 10 min
- Customização: 8 min
- Criar novo ISO: 2 min

**6x MAIS RÁPIDO que build from scratch!**

---

## Como Usar (Xubuntu)

### Um Comando:

```bash
sudo ./customize-debian-live.sh
```

Isso vai:
1. ✅ Baixar Debian Live (2.7GB)
2. ✅ Extrair e customizar
3. ✅ Adicionar seus bookmarks brasileiros
4. ✅ Configurar CleanBrowsing DNS (bloqueio de sites adultos)
5. ✅ Configurar modo kiosk automático
6. ✅ Recriar ISO otimizada

---

## Resultado

**Arquivo:** `kiosk-linux-custom.iso`

### Gravar no Pen Drive:

```bash
sudo dd if=kiosk-linux-custom.iso of=/dev/sdc bs=4M status=progress && sync
```

---

## O Que Está Incluído

✅ **Debian 12 Live XFCE** (leve e rápido)
✅ **Modo Kiosk Automático** (abre browser ao ligar)
✅ **Bookmarks Brasileiros:**
   - Globo
   - UOL
   - Gazeta do Povo
   - YouTube
   - ESPN Brasil
   - Gazeta Esportiva

✅ **Bloqueio de Conteúdo Adulto:**
   - DNS: CleanBrowsing Family Filter (185.228.168.168)
   - SafeSearch enforced
   - YouTube Restricted Mode

✅ **Segurança:**
   - Sem downloads
   - Sem acesso ao terminal (modo kiosk)
   - Reseta tudo ao reiniciar

✅ **Liberdade para Usuário:**
   - Pode acessar qualquer site seguro
   - Pode digitar URLs
   - Pode fazer buscas no Google
   - Apenas sites adultos bloqueados

---

## Por Que é Mais Rápido?

### Método Antigo (build-iso.sh):
- ❌ Bootstrap Debian do zero
- ❌ Instala 100+ pacotes um por um
- ❌ Comprime 1.5GB de arquivos
- ⏰ **Tempo: 2-3 horas**

### Método Novo (customize-debian-live.sh):
- ✅ Usa Debian Live já pronto
- ✅ Apenas adiciona configs
- ✅ Recomprime só o que mudou
- ⏰ **Tempo: 20 minutos**

---

## Requisitos

```bash
sudo apt-get install -y squashfs-tools xorriso rsync wget
```

(O script verifica e instala se necessário)

---

## Troubleshooting

### Download lento?
Use mirror alternativo ou baixe via navegador de:
https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/

### Sem espaço em disco?
Precisa de ~10GB livres temporariamente

### Erro no unsquashfs?
```bash
sudo apt-get install squashfs-tools
```

---

## Comparação

| Aspecto | Build do Zero | Customizar Live |
|---------|---------------|-----------------|
| Tempo | 2-3 horas | 20 minutos |
| Complexidade | Alta | Baixa |
| Resultado | Idêntico | Idêntico |
| Recomendado | ❌ | ✅ |

---

## Próximos Passos

1. **Rodar o script:** `sudo ./customize-debian-live.sh`
2. **Esperar 20 minutos** ☕
3. **Gravar no pen drive**
4. **Bootar e usar!**

🎉 **Pronto!**
