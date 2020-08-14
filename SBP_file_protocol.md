#  SPB File protocol (credits: gpsbabel)

## Waypoint structure

- UINT8 HDOP;        /* HDOP [0..51] with resolution 0.2 */
- UINT8 SVIDCnt;        /* Number of SVs in solution [0 to 12] */
- UINT16 UtcSec;        /* UTC Second [0 to 59] in seconds with resolution 0.001 */
- UINT32 date_time_UTC_packed; /* refer to protocol doc*/
- UINT32 SVIDList;    /* SVs in solution:  Bit 0=1: SV1, Bit 1=1: SV2, ... , Bit 31=1: SV32 */
- INT32 Lat;            /* Latitude [-90 to 90] in degrees with resolution 0.0000001 */
- INT32 Lon;            /* Longitude [-180 to 180] in degrees with resolution 0.0000001 */
- INT32 AltCM;            /* Altitude from Mean Sea Level in centi meters */
- UINT16 Sog;            /* Speed Over Ground in m/sec with resolution 0.01 */
- UINT16 Cog;            /* Course Over Ground [0 to 360] in degrees with resolution 0.01 */
- INT16 ClmbRte;        /* Climb rate in m/sec with resolution 0.01 */
- UINT8 bitFlags;     /* bitFlags, default 0x00,    bit 0=1 indicate the first point after power on */
- UINT8 reserved;

## Header structure

A complete SBP file contains 64 bytes header,
Here is the definition of the SBP header
- BYTE 0 ~1 : true SBP header length
- BYTE 2~63:  MID_FILE_ID(0xfd)
- Will stuff 0xff for remaining bytes

MID_FILE_ID(0xfd) contains the following payload :
  User Name, Serial Number, Log Rate, Firmware Version
- field separator:","
- User Name : MAX CHAR(13)
- Serial Number : MAX CHAR(8)
- Log Rate : MAX CHAR 3, 0..255 in seconds
- Firmware Version  :  MAX CHAR (13)
