import { useState, useEffect } from 'react';
import { Button } from './ui/button';
import { Card, CardContent } from './ui/card';
import { 
  ArrowLeft, 
  Printer, 
  CheckCircle, 
  Bluetooth,
  Wifi,
  Search,
  Info,
  Settings
} from 'lucide-react';

interface PrinterScreenProps {
  onBack: () => void;
}

interface BluetoothDevice {
  id: string;
  name: string;
  macAddress: string;
  type: 'bluetooth' | 'wifi';
  connected: boolean;
}

export function PrinterScreen({ onBack }: PrinterScreenProps) {
  const [isLoading, setIsLoading] = useState(true);
  const [devices, setDevices] = useState<BluetoothDevice[]>([]);
  const [savedPrinterId, setSavedPrinterId] = useState<string | null>(null);
  const [isScanning, setIsScanning] = useState(false);

  // Dispositivos simulados para la demo
  const mockDevices: BluetoothDevice[] = [
    {
      id: '1',
      name: 'EPSON TM-T82',
      macAddress: '00:11:22:33:44:55',
      type: 'bluetooth',
      connected: true
    },
    {
      id: '2', 
      name: 'STAR TSP143III',
      macAddress: '00:22:33:44:55:66',
      type: 'bluetooth',
      connected: false
    },
    {
      id: '3',
      name: 'CITIZEN CT-S310II',
      macAddress: '00:33:44:55:66:77', 
      type: 'bluetooth',
      connected: true
    },
    {
      id: '4',
      name: 'Impresora WiFi Red Municipal',
      macAddress: '192.168.1.100',
      type: 'wifi',
      connected: true
    }
  ];

  useEffect(() => {
    // Cargar impresora guardada desde localStorage
    const savedId = localStorage.getItem('printer_id');
    const savedName = localStorage.getItem('printer_name');
    
    if (savedId) {
      setSavedPrinterId(savedId);
    }
    
    // Simular carga de dispositivos
    setTimeout(() => {
      setDevices(mockDevices);
      setIsLoading(false);
    }, 1500);
  }, []);

  const handleScanForDevices = async () => {
    setIsScanning(true);
    
    // Simular búsqueda de dispositivos
    await new Promise(resolve => setTimeout(resolve, 2000));
    
    // Agregar un nuevo dispositivo simulado
    const newDevice: BluetoothDevice = {
      id: Date.now().toString(),
      name: 'NUEVA IMPRESORA',
      macAddress: '00:AA:BB:CC:DD:EE',
      type: 'bluetooth',
      connected: false
    };
    
    setDevices(prev => [...prev, newDevice]);
    setIsScanning(false);
  };

  const handleSelectDevice = (device: BluetoothDevice) => {
    // Guardar en localStorage
    localStorage.setItem('printer_id', device.id);
    localStorage.setItem('printer_name', device.name);
    localStorage.setItem('printer_mac', device.macAddress);
    
    setSavedPrinterId(device.id);
    
    // Mostrar confirmación y regresar
    alert(`Impresora "${device.name}" configurada exitosamente`);
    setTimeout(() => {
      onBack();
    }, 500);
  };

  const getDeviceIcon = (device: BluetoothDevice) => {
    return device.type === 'wifi' ? Wifi : Bluetooth;
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary/5 via-red-50/50 to-primary/10">
      {/* Header */}
      <header className="bg-white/80 backdrop-blur-lg border-b border-primary/10 sticky top-0 z-50">
        <div className="max-w-2xl mx-auto px-6 py-4 flex items-center justify-between">
          <div className="flex items-center space-x-4">
            <Button 
              variant="ghost" 
              onClick={onBack}
              className="flex items-center space-x-2 text-muted-foreground hover:text-foreground rounded-2xl"
            >
              <ArrowLeft className="w-5 h-5" />
            </Button>
            <h1 className="text-primary tracking-tight">Configurar Impresora</h1>
          </div>
          
          <Button 
            variant="ghost" 
            onClick={handleScanForDevices}
            disabled={isScanning}
            className="flex items-center space-x-2 text-muted-foreground hover:text-foreground rounded-2xl"
            title="Buscar Dispositivos"
          >
            <Search className={`w-4 h-4 ${isScanning ? 'animate-spin' : ''}`} />
          </Button>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-2xl mx-auto px-6 py-8">
        <div className="space-y-6">
          
          {/* Information Card */}
          <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl overflow-hidden bg-white">
            <CardContent className="p-6">
              <div className="flex items-start space-x-4">
                <div className="w-10 h-10 bg-gradient-to-br from-blue-100 to-blue-200 rounded-2xl flex items-center justify-center flex-shrink-0">
                  <Info className="w-5 h-5 text-blue-600" />
                </div>
                <div>
                  <h3 className="text-foreground mb-2">Configuración de Impresora</h3>
                  <p className="text-muted-foreground text-sm leading-relaxed">
                    Selecciona una impresora Bluetooth o WiFi para imprimir las boletas de fiscalización. 
                    Asegúrate de que el dispositivo esté encendido y emparejado con el sistema.
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Available Printers */}
          <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl overflow-hidden bg-white">
            <CardContent className="p-6">
              <div className="flex items-center justify-between mb-6">
                <div className="flex items-center space-x-3">
                  <Settings className="w-5 h-5 text-primary" />
                  <h3 className="text-foreground">Impresoras Disponibles</h3>
                </div>
                <div className="flex items-center space-x-2">
                  {isScanning && (
                    <div className="w-2 h-2 bg-blue-500 rounded-full animate-pulse"></div>
                  )}
                  <span className="text-sm text-muted-foreground">
                    {isScanning ? 'Buscando...' : `${devices.length} encontradas`}
                  </span>
                </div>
              </div>

              {isLoading ? (
                <div className="flex items-center justify-center py-12">
                  <div className="flex flex-col items-center space-y-4">
                    <div className="w-8 h-8 border-2 border-primary/30 border-t-primary rounded-full animate-spin"></div>
                    <p className="text-muted-foreground text-sm">Buscando impresoras...</p>
                  </div>
                </div>
              ) : devices.length === 0 ? (
                <div className="text-center py-12">
                  <Printer className="w-12 h-12 text-muted-foreground/50 mx-auto mb-4" />
                  <p className="text-muted-foreground">
                    No se encontraron impresoras disponibles
                  </p>
                  <Button 
                    variant="outline" 
                    onClick={handleScanForDevices}
                    className="mt-4 rounded-2xl"
                  >
                    Buscar Dispositivos
                  </Button>
                </div>
              ) : (
                <div className="space-y-3">
                  {devices.map((device) => {
                    const isSelected = device.id === savedPrinterId;
                    const DeviceIcon = getDeviceIcon(device);
                    
                    return (
                      <Card
                        key={device.id}
                        className={`border-0 shadow-sm rounded-2xl overflow-hidden cursor-pointer transition-all duration-200 hover:shadow-md hover:scale-[1.01] ${
                          isSelected 
                            ? 'bg-gradient-to-r from-primary/5 to-primary/10 shadow-primary/10' 
                            : 'bg-muted/20 hover:bg-muted/30'
                        }`}
                        onClick={() => handleSelectDevice(device)}
                      >
                        <CardContent className="p-4">
                          <div className="flex items-center justify-between">
                            <div className="flex items-center space-x-4">
                              <div className={`w-12 h-12 rounded-2xl flex items-center justify-center ${
                                isSelected 
                                  ? 'bg-gradient-to-br from-primary/20 to-primary/30' 
                                  : 'bg-muted/40'
                              }`}>
                                <DeviceIcon className={`w-6 h-6 ${
                                  isSelected ? 'text-primary' : 'text-muted-foreground'
                                }`} />
                              </div>
                              <div>
                                <h4 className={`font-medium ${
                                  isSelected ? 'text-primary' : 'text-foreground'
                                }`}>
                                  {device.name}
                                </h4>
                                <div className="flex items-center space-x-3 text-sm text-muted-foreground">
                                  <span>{device.macAddress}</span>
                                  <div className="flex items-center space-x-1">
                                    <div className={`w-2 h-2 rounded-full ${
                                      device.connected ? 'bg-emerald-500' : 'bg-gray-400'
                                    }`}></div>
                                    <span>{device.connected ? 'Conectado' : 'Disponible'}</span>
                                  </div>
                                </div>
                              </div>
                            </div>
                            
                            {isSelected && (
                              <CheckCircle className="w-6 h-6 text-primary" />
                            )}
                          </div>
                        </CardContent>
                      </Card>
                    );
                  })}
                </div>
              )}

              {!isLoading && devices.length > 0 && (
                <div className="mt-6 pt-4 border-t border-border">
                  <Button 
                    variant="outline" 
                    onClick={handleScanForDevices}
                    disabled={isScanning}
                    className="w-full h-12 rounded-2xl flex items-center justify-center space-x-2"
                  >
                    <Search className={`w-4 h-4 ${isScanning ? 'animate-spin' : ''}`} />
                    <span>{isScanning ? 'Buscando...' : 'Buscar Más Dispositivos'}</span>
                  </Button>
                </div>
              )}
            </CardContent>
          </Card>

          {/* Current Selection */}
          {savedPrinterId && (
            <Card className="border-0 shadow-lg shadow-emerald-500/10 rounded-3xl overflow-hidden bg-gradient-to-r from-emerald-50 to-green-50">
              <CardContent className="p-6">
                <div className="flex items-center space-x-4">
                  <div className="w-10 h-10 bg-gradient-to-br from-emerald-100 to-emerald-200 rounded-2xl flex items-center justify-center">
                    <CheckCircle className="w-5 h-5 text-emerald-600" />
                  </div>
                  <div>
                    <h4 className="text-emerald-800 font-medium mb-1">Impresora Configurada</h4>
                    <p className="text-emerald-600 text-sm">
                      {localStorage.getItem('printer_name')} está lista para usar
                    </p>
                  </div>
                </div>
              </CardContent>
            </Card>
          )}
        </div>
      </main>
    </div>
  );
}