import { useState, useEffect } from 'react';
import { Button } from './ui/button';
import { Input } from './ui/input';
import { Label } from './ui/label';
import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from './ui/select';
import { Textarea } from './ui/textarea';
import { 
  ArrowLeft, 
  Camera, 
  FileText, 
  Printer,
  Car,
  User,
  AlertTriangle,
  RefreshCw,
  Trash2,
  Badge,
  Building2,
  Clock
} from 'lucide-react';

interface InspectionFormProps {
  onBack: () => void;
}

export function InspectionForm({ onBack }: InspectionFormProps) {
  const [formData, setFormData] = useState({
    placa: '',
    empresa: '',
    conductor: '',
    licencia: '',
    fiscalizador: '',
    motivo: '',
    conforme: '',
    descripciones: '',
    observacionesInspector: ''
  });

  const [fechaHoraActual, setFechaHoraActual] = useState('');
  const [fotoLicencia, setFotoLicencia] = useState<File | null>(null);
  const [isProcessing, setIsProcessing] = useState(false);

  const opcionesConforme = ['Sí', 'No', 'Parcialmente'];

  // Cargar datos del fiscalizador desde localStorage
  useEffect(() => {
    const savedFiscalizador = localStorage.getItem('codigo_fiscalizador');
    if (savedFiscalizador) {
      setFormData(prev => ({ ...prev, fiscalizador: savedFiscalizador }));
    }
    actualizarFechaHora();
  }, []);

  const actualizarFechaHora = () => {
    const now = new Date();
    const formatter = new Intl.DateTimeFormat('es-PE', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
      hour12: false
    });
    setFechaHoraActual(formatter.format(now));
  };

  const handleInputChange = (field: string, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
    
    // Guardar código del fiscalizador para la próxima vez
    if (field === 'fiscalizador') {
      localStorage.setItem('codigo_fiscalizador', value);
    }
  };

  const limpiarCampos = () => {
    setFormData(prev => ({
      placa: '',
      empresa: '',
      conductor: '',
      licencia: '',
      fiscalizador: prev.fiscalizador, // Mantener el fiscalizador
      motivo: '',
      conforme: '',
      descripciones: '',
      observacionesInspector: ''
    }));
    setFotoLicencia(null);
  };

  const tomarFoto = () => {
    // Simular toma de foto
    const input = document.createElement('input');
    input.type = 'file';
    input.accept = 'image/*';
    input.capture = 'environment';
    input.onchange = (e) => {
      const file = (e.target as HTMLInputElement).files?.[0];
      if (file) {
        setFotoLicencia(file);
      }
    };
    input.click();
  };

  const mostrarPdf = () => {
    alert('Generando PDF de vista previa...');
    // Aquí se implementaría la lógica para generar y mostrar el PDF
  };

  const finalizarEImprimir = async () => {
    // Validación de campos requeridos
    const camposRequeridos = ['placa', 'empresa', 'conductor', 'licencia', 'fiscalizador', 'motivo'];
    const camposFaltantes = camposRequeridos.filter(campo => !formData[campo as keyof typeof formData].trim());
    
    if (camposFaltantes.length > 0) {
      alert('Por favor, complete todos los campos obligatorios.');
      return;
    }

    setIsProcessing(true);
    
    try {
      // Simular proceso de guardado e impresión
      await new Promise(resolve => setTimeout(resolve, 2000));
      
      alert('Fiscalización completada e impresa exitosamente');
      limpiarCampos();
    } catch (error) {
      alert('Error al procesar la fiscalización');
    } finally {
      setIsProcessing(false);
    }
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
            <h1 className="text-primary tracking-tight">Formulario de Fiscalización</h1>
          </div>
          
          <Button 
            variant="ghost" 
            onClick={limpiarCampos}
            className="flex items-center space-x-2 text-muted-foreground hover:text-foreground rounded-2xl"
            title="Limpiar Formulario"
          >
            <Trash2 className="w-4 h-4" />
          </Button>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-2xl mx-auto px-6 py-8">
        <div className="space-y-6">
          
          {/* Información General */}
          <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl overflow-hidden bg-white">
            <CardHeader className="pb-4 bg-gradient-to-r from-red-50/50 to-primary/5">
              <CardTitle className="flex items-center justify-between text-foreground">
                <div className="flex items-center space-x-3">
                  <div className="w-10 h-10 bg-gradient-to-br from-primary/20 to-red-600/20 rounded-2xl flex items-center justify-center">
                    <AlertTriangle className="w-5 h-5 text-primary" />
                  </div>
                  <span>Información General</span>
                </div>
                <div className="text-sm text-muted-foreground">
                  Complete todos los campos con precisión
                </div>
              </CardTitle>
            </CardHeader>
            <CardContent className="p-6 space-y-4">
              
              {/* Fecha y Hora Actual */}
              <div className="flex items-center justify-between p-4 bg-muted/20 rounded-2xl">
                <div className="flex items-center space-x-3">
                  <Clock className="w-5 h-5 text-primary" />
                  <div>
                    <p className="text-sm text-muted-foreground">Fecha y Hora de Intervención</p>
                    <p className="text-foreground font-medium">{fechaHoraActual}</p>
                  </div>
                </div>
                <Button 
                  variant="ghost" 
                  size="sm" 
                  onClick={actualizarFechaHora}
                  className="rounded-xl"
                  title="Actualizar Hora"
                >
                  <RefreshCw className="w-4 h-4" />
                </Button>
              </div>

              {/* Código del Fiscalizador */}
              <div className="space-y-2">
                <Label htmlFor="fiscalizador" className="text-sm text-foreground/80">
                  Código del Fiscalizador *
                </Label>
                <div className="relative">
                  <div className="absolute left-4 top-1/2 transform -translate-y-1/2">
                    <Badge className="w-5 h-5 text-muted-foreground" />
                  </div>
                  <Input
                    id="fiscalizador"
                    placeholder="FISC1234"
                    value={formData.fiscalizador}
                    onChange={(e) => handleInputChange('fiscalizador', e.target.value)}
                    className="pl-12 h-12 bg-muted/30 border-0 rounded-2xl focus:bg-white transition-colors uppercase"
                    required
                  />
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Datos del Vehículo y Empresa */}
          <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl overflow-hidden bg-white">
            <CardHeader className="pb-4 bg-gradient-to-r from-red-50/50 to-primary/5">
              <CardTitle className="flex items-center space-x-3 text-foreground">
                <div className="w-10 h-10 bg-gradient-to-br from-primary/20 to-red-600/20 rounded-2xl flex items-center justify-center">
                  <Car className="w-5 h-5 text-primary" />
                </div>
                <span>Datos del Vehículo y Empresa</span>
              </CardTitle>
            </CardHeader>
            <CardContent className="p-6 space-y-4">
              
              {/* Número de Placa */}
              <div className="space-y-2">
                <Label htmlFor="placa" className="text-sm text-foreground/80">
                  Número de Placa *
                </Label>
                <Input
                  id="placa"
                  placeholder="V1A-123"
                  value={formData.placa}
                  onChange={(e) => handleInputChange('placa', e.target.value)}
                  className="h-12 bg-muted/30 border-0 rounded-2xl focus:bg-white transition-colors uppercase"
                  required
                />
              </div>

              {/* Nombre de la Empresa */}
              <div className="space-y-2">
                <Label htmlFor="empresa" className="text-sm text-foreground/80">
                  Nombre de la Empresa *
                </Label>
                <div className="relative">
                  <div className="absolute left-4 top-1/2 transform -translate-y-1/2">
                    <Building2 className="w-5 h-5 text-muted-foreground" />
                  </div>
                  <Input
                    id="empresa"
                    placeholder="Transportes Perú S.A."
                    value={formData.empresa}
                    onChange={(e) => handleInputChange('empresa', e.target.value)}
                    className="pl-12 h-12 bg-muted/30 border-0 rounded-2xl focus:bg-white transition-colors"
                    required
                  />
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Información del Conductor */}
          <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl overflow-hidden bg-white">
            <CardHeader className="pb-4 bg-gradient-to-r from-red-50/50 to-primary/5">
              <CardTitle className="flex items-center space-x-3 text-foreground">
                <div className="w-10 h-10 bg-gradient-to-br from-primary/20 to-red-600/20 rounded-2xl flex items-center justify-center">
                  <User className="w-5 h-5 text-primary" />
                </div>
                <span>Información del Conductor</span>
              </CardTitle>
            </CardHeader>
            <CardContent className="p-6 space-y-4">
              
              {/* Nombre del Conductor */}
              <div className="space-y-2">
                <Label htmlFor="conductor" className="text-sm text-foreground/80">
                  Nombre Completo del Conductor *
                </Label>
                <Input
                  id="conductor"
                  placeholder="Juan Pérez Ramírez"
                  value={formData.conductor}
                  onChange={(e) => handleInputChange('conductor', e.target.value)}
                  className="h-12 bg-muted/30 border-0 rounded-2xl focus:bg-white transition-colors"
                  required
                />
              </div>

              {/* Número de Licencia */}
              <div className="space-y-2">
                <Label htmlFor="licencia" className="text-sm text-foreground/80">
                  Número de Licencia *
                </Label>
                <div className="flex space-x-3">
                  <Input
                    id="licencia"
                    placeholder="B1234567"
                    value={formData.licencia}
                    onChange={(e) => handleInputChange('licencia', e.target.value)}
                    className="h-12 bg-muted/30 border-0 rounded-2xl focus:bg-white transition-colors uppercase"
                    required
                  />
                  <Button 
                    type="button" 
                    variant="outline" 
                    onClick={tomarFoto}
                    className="h-12 px-4 bg-white border-0 rounded-2xl shadow-md hover:shadow-lg transition-all"
                    title="Tomar foto de licencia"
                  >
                    <Camera className="w-4 h-4" />
                  </Button>
                </div>
                {fotoLicencia && (
                  <p className="text-sm text-emerald-600 flex items-center space-x-1">
                    <span>✓</span>
                    <span>Foto capturada: {fotoLicencia.name}</span>
                  </p>
                )}
              </div>
            </CardContent>
          </Card>

          {/* Detalles de la Fiscalización */}
          <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl overflow-hidden bg-white">
            <CardHeader className="pb-4 bg-gradient-to-r from-red-50/50 to-orange-50/50">
              <CardTitle className="flex items-center space-x-3 text-foreground">
                <div className="w-10 h-10 bg-gradient-to-br from-red-100 to-orange-100 rounded-2xl flex items-center justify-center">
                  <AlertTriangle className="w-5 h-5 text-red-600" />
                </div>
                <span>Detalles de la Fiscalización</span>
              </CardTitle>
            </CardHeader>
            <CardContent className="p-6 space-y-4">
              
              {/* Motivo */}
              <div className="space-y-2">
                <Label htmlFor="motivo" className="text-sm text-foreground/80">
                  Motivo *
                </Label>
                <Textarea
                  id="motivo"
                  placeholder="Falta de documentos, exceso de velocidad, etc."
                  value={formData.motivo}
                  onChange={(e) => handleInputChange('motivo', e.target.value)}
                  className="min-h-20 bg-muted/30 border-0 rounded-2xl focus:bg-white transition-colors resize-none"
                  required
                />
              </div>

              {/* Conforme */}
              <div className="space-y-2">
                <Label htmlFor="conforme" className="text-sm text-foreground/80">
                  ¿Conforme? *
                </Label>
                <Select onValueChange={(value) => handleInputChange('conforme', value)}>
                  <SelectTrigger className="h-12 bg-muted/30 border-0 rounded-2xl">
                    <SelectValue placeholder="Seleccionar respuesta" />
                  </SelectTrigger>
                  <SelectContent className="rounded-2xl border-0 shadow-xl">
                    {opcionesConforme.map((opcion) => (
                      <SelectItem key={opcion} value={opcion}>
                        {opcion}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              {/* Descripciones */}
              <div className="space-y-2">
                <Label htmlFor="descripciones" className="text-sm text-foreground/80">
                  Descripciones Adicionales
                </Label>
                <Textarea
                  id="descripciones"
                  placeholder="Vehículo sin SOAT, documentos vencidos, etc."
                  value={formData.descripciones}
                  onChange={(e) => handleInputChange('descripciones', e.target.value)}
                  className="min-h-20 bg-muted/30 border-0 rounded-2xl focus:bg-white transition-colors resize-none"
                />
              </div>

              {/* Observaciones del Inspector */}
              <div className="space-y-2">
                <Label htmlFor="observacionesInspector" className="text-sm text-foreground/80">
                  Observaciones del Inspector
                </Label>
                <Textarea
                  id="observacionesInspector"
                  placeholder="El conductor mostró actitud colaborativa, etc."
                  value={formData.observacionesInspector}
                  onChange={(e) => handleInputChange('observacionesInspector', e.target.value)}
                  className="min-h-20 bg-muted/30 border-0 rounded-2xl focus:bg-white transition-colors resize-none"
                />
              </div>
            </CardContent>
          </Card>

          {/* Actions */}
          <div className="flex flex-col space-y-3 pt-4">
            <Button 
              type="button" 
              variant="outline" 
              onClick={mostrarPdf}
              className="h-14 bg-white border-0 rounded-2xl shadow-lg hover:shadow-xl transition-all flex items-center justify-center space-x-2"
            >
              <FileText className="w-5 h-5" />
              <span>Ver Boleta (PDF)</span>
            </Button>
            
            <Button 
              onClick={finalizarEImprimir}
              disabled={isProcessing}
              className="h-14 bg-gradient-to-r from-primary to-red-600 hover:from-primary/90 hover:to-red-600/90 text-white rounded-2xl shadow-lg shadow-primary/25 border-0 transition-all duration-200 hover:shadow-xl hover:shadow-primary/30 hover:scale-[1.02] flex items-center justify-center space-x-2 disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:scale-100"
            >
              {isProcessing ? (
                <>
                  <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                  <span>Imprimiendo...</span>
                </>
              ) : (
                <>
                  <Printer className="w-5 h-5" />
                  <span>Finalizar e Imprimir</span>
                </>
              )}
            </Button>
          </div>
        </div>
      </main>
    </div>
  );
}