import { useState, useEffect } from 'react';
import { Button } from './ui/button';
import { Card, CardContent, CardHeader, CardTitle } from './ui/card';
import { Badge } from './ui/badge';
import { Avatar, AvatarFallback } from './ui/avatar';
import { Progress } from './ui/progress';
import { Tabs, TabsContent, TabsList, TabsTrigger } from './ui/tabs';
import { Input } from './ui/input';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from './ui/select';
import { 
  ArrowLeft,
  Users,
  FileText,
  TrendingUp,
  Calendar,
  Search,
  Filter,
  Download,
  Eye,
  Camera,
  CheckCircle,
  XCircle,
  AlertTriangle,
  BarChart3,
  PieChart,
  Activity
} from 'lucide-react';
import laJoyaLogo from 'figma:asset/573ae69949bb1650d02f03b6b86b01620a91b133.png';

interface DashboardProps {
  onBack: () => void;
}

interface Boleta {
  id: string;
  placa: string;
  empresa: string;
  conductor: string;
  numeroLicencia: string;
  fiscalizador: string;
  motivo: string;
  conforme: 'Sí' | 'No' | 'Parcialmente';
  fecha: Date;
  fotoLicencia?: string;
  descripciones?: string;
  observaciones?: string;
}

interface Inspector {
  id: string;
  nombre: string;
  codigo: string;
  boletas: number;
  conformes: number;
  noConformes: number;
  ultimaActividad: Date;
}

// Mock data
const mockBoletas: Boleta[] = [
  {
    id: '1',
    placa: 'ABC-123',
    empresa: 'Transportes San Martín',
    conductor: 'Juan Carlos Pérez',
    numeroLicencia: 'B123456789',
    fiscalizador: 'FISC001',
    motivo: 'Revisión rutinaria de documentos',
    conforme: 'Sí',
    fecha: new Date('2024-01-15T10:30:00'),
    fotoLicencia: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=200&h=120&fit=crop',
    descripciones: 'Documentación completa y en regla'
  },
  {
    id: '2',
    placa: 'DEF-456',
    empresa: 'Express Arequipa',
    conductor: 'María Elena Rodriguez',
    numeroLicencia: 'B987654321',
    fiscalizador: 'FISC002',
    motivo: 'Verificación de licencia vencida',
    conforme: 'No',
    fecha: new Date('2024-01-15T11:45:00'),
    fotoLicencia: 'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=200&h=120&fit=crop',
    observaciones: 'Licencia vencida desde hace 3 meses'
  },
  {
    id: '3',
    placa: 'GHI-789',
    empresa: 'Turismo La Joya',
    conductor: 'Carlos Alberto Mendoza',
    numeroLicencia: 'B456789123',
    fiscalizador: 'FISC001',
    motivo: 'Control de seguridad vehicular',
    conforme: 'Parcialmente',
    fecha: new Date('2024-01-15T14:20:00'),
    fotoLicencia: 'https://images.unsplash.com/photo-1597223557154-721c1cecc4b0?w=200&h=120&fit=crop',
    descripciones: 'Licencia válida pero falta certificado de revisión técnica'
  },
  {
    id: '4',
    placa: 'JKL-012',
    empresa: 'Servicios Unidos',
    conductor: 'Ana Patricia Flores',
    numeroLicencia: 'B789123456',
    fiscalizador: 'FISC003',
    motivo: 'Inspección de documentos de carga',
    conforme: 'Sí',
    fecha: new Date('2024-01-15T16:10:00'),
    fotoLicencia: 'https://images.unsplash.com/photo-1494790108755-2616c045c7d3?w=200&h=120&fit=crop',
    descripciones: 'Todo en orden, documentación completa'
  },
  {
    id: '5',
    placa: 'MNO-345',
    empresa: 'Transportes del Sur',
    conductor: 'Roberto Silva Vargas',
    numeroLicencia: 'B321654987',
    fiscalizador: 'FISC002',
    motivo: 'Verificación de permisos especiales',
    conforme: 'No',
    fecha: new Date('2024-01-14T09:15:00'),
    fotoLicencia: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=120&fit=crop',
    observaciones: 'Falta permiso para transporte de pasajeros'
  }
];

const mockInspectores: Inspector[] = [
  {
    id: 'FISC001',
    nombre: 'Carlos Mendoza',
    codigo: 'FISC001',
    boletas: 15,
    conformes: 12,
    noConformes: 3,
    ultimaActividad: new Date('2024-01-15T16:45:00')
  },
  {
    id: 'FISC002',
    nombre: 'Ana Rodriguez',
    codigo: 'FISC002',
    boletas: 22,
    conformes: 18,
    noConformes: 4,
    ultimaActividad: new Date('2024-01-15T15:20:00')
  },
  {
    id: 'FISC003',
    nombre: 'Miguel Torres',
    codigo: 'FISC003',
    boletas: 8,
    conformes: 6,
    noConformes: 2,
    ultimaActividad: new Date('2024-01-15T14:10:00')
  }
];

export function Dashboard({ onBack }: DashboardProps) {
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedInspector, setSelectedInspector] = useState<string>('all');
  const [selectedPeriod, setSelectedPeriod] = useState<string>('today');
  const [boletas] = useState<Boleta[]>(mockBoletas);
  const [inspectores] = useState<Inspector[]>(mockInspectores);

  // Estadísticas calculadas
  const totalBoletas = boletas.length;
  const totalConformes = boletas.filter(b => b.conforme === 'Sí').length;
  const totalNoConformes = boletas.filter(b => b.conforme === 'No').length;
  const totalParciales = boletas.filter(b => b.conforme === 'Parcialmente').length;
  const porcentajeConformidad = Math.round((totalConformes / totalBoletas) * 100);

  // Filtros
  const filteredBoletas = boletas.filter(boleta => {
    const matchesSearch = 
      boleta.placa.toLowerCase().includes(searchTerm.toLowerCase()) ||
      boleta.empresa.toLowerCase().includes(searchTerm.toLowerCase()) ||
      boleta.conductor.toLowerCase().includes(searchTerm.toLowerCase()) ||
      boleta.fiscalizador.toLowerCase().includes(searchTerm.toLowerCase());
    
    const matchesInspector = selectedInspector === 'all' || boleta.fiscalizador === selectedInspector;
    
    return matchesSearch && matchesInspector;
  });

  const getConformeColor = (conforme: string) => {
    switch (conforme) {
      case 'Sí': return 'bg-green-100 text-green-800';
      case 'No': return 'bg-red-100 text-red-800';
      case 'Parcialmente': return 'bg-yellow-100 text-yellow-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  };

  const getConformeIcon = (conforme: string) => {
    switch (conforme) {
      case 'Sí': return <CheckCircle className="w-4 h-4" />;
      case 'No': return <XCircle className="w-4 h-4" />;
      case 'Parcialmente': return <AlertTriangle className="w-4 h-4" />;
      default: return null;
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary/5 via-red-50/50 to-primary/10">
      {/* Header */}
      <header className="bg-white/80 backdrop-blur-lg border-b border-primary/10 sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-6 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <Button
                variant="ghost"
                onClick={onBack}
                className="rounded-2xl"
              >
                <ArrowLeft className="w-4 h-4" />
              </Button>
              <div className="flex items-center space-x-3">
                <div className="w-10 h-6 bg-white rounded-xl flex items-center justify-center p-1 shadow-sm">
                  <img 
                    src={laJoyaLogo} 
                    alt="La Joya" 
                    className="w-full h-full object-contain"
                  />
                </div>
                <div>
                  <h1 className="text-primary tracking-tight">Dashboard</h1>
                  <p className="text-sm text-muted-foreground">Panel de control administrativo</p>
                </div>
              </div>
            </div>
            <div className="flex items-center space-x-2">
              <Button variant="outline" className="rounded-2xl">
                <Download className="w-4 h-4 mr-2" />
                Exportar
              </Button>
            </div>
          </div>
        </div>
      </header>

      <main className="max-w-7xl mx-auto px-6 py-8">
        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl bg-gradient-to-br from-white to-blue-50/30">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground mb-1">Total Boletas</p>
                  <p className="text-3xl text-primary tracking-tight">{totalBoletas}</p>
                </div>
                <div className="w-12 h-12 bg-gradient-to-br from-blue-500 to-blue-600 rounded-2xl flex items-center justify-center">
                  <FileText className="w-6 h-6 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl bg-gradient-to-br from-white to-green-50/30">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground mb-1">Conformes</p>
                  <p className="text-3xl text-green-600 tracking-tight">{totalConformes}</p>
                </div>
                <div className="w-12 h-12 bg-gradient-to-br from-green-500 to-green-600 rounded-2xl flex items-center justify-center">
                  <CheckCircle className="w-6 h-6 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl bg-gradient-to-br from-white to-red-50/30">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground mb-1">No Conformes</p>
                  <p className="text-3xl text-red-600 tracking-tight">{totalNoConformes}</p>
                </div>
                <div className="w-12 h-12 bg-gradient-to-br from-red-500 to-red-600 rounded-2xl flex items-center justify-center">
                  <XCircle className="w-6 h-6 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>

          <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl bg-gradient-to-br from-white to-orange-50/30">
            <CardContent className="p-6">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-muted-foreground mb-1">Conformidad</p>
                  <p className="text-3xl text-orange-600 tracking-tight">{porcentajeConformidad}%</p>
                </div>
                <div className="w-12 h-12 bg-gradient-to-br from-orange-500 to-orange-600 rounded-2xl flex items-center justify-center">
                  <TrendingUp className="w-6 h-6 text-white" />
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        <Tabs defaultValue="overview" className="space-y-6">
          <TabsList className="grid w-full grid-cols-4 bg-white rounded-2xl p-1 shadow-sm">
            <TabsTrigger value="overview" className="rounded-xl">Vista General</TabsTrigger>
            <TabsTrigger value="inspectors" className="rounded-xl">Inspectores</TabsTrigger>
            <TabsTrigger value="records" className="rounded-xl">Registros</TabsTrigger>
            <TabsTrigger value="photos" className="rounded-xl">Fotos</TabsTrigger>
          </TabsList>

          {/* Vista General */}
          <TabsContent value="overview" className="space-y-6">
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              {/* Gráfico de Conformidad */}
              <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl">
                <CardHeader>
                  <CardTitle className="flex items-center space-x-2">
                    <PieChart className="w-5 h-5 text-primary" />
                    <span>Distribución de Conformidad</span>
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-2">
                        <div className="w-3 h-3 bg-green-500 rounded-full"></div>
                        <span className="text-sm">Conforme</span>
                      </div>
                      <span className="text-sm">{totalConformes} ({Math.round((totalConformes/totalBoletas)*100)}%)</span>
                    </div>
                    <Progress value={(totalConformes/totalBoletas)*100} className="h-2" />
                    
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-2">
                        <div className="w-3 h-3 bg-red-500 rounded-full"></div>
                        <span className="text-sm">No Conforme</span>
                      </div>
                      <span className="text-sm">{totalNoConformes} ({Math.round((totalNoConformes/totalBoletas)*100)}%)</span>
                    </div>
                    <Progress value={(totalNoConformes/totalBoletas)*100} className="h-2" />
                    
                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-2">
                        <div className="w-3 h-3 bg-yellow-500 rounded-full"></div>
                        <span className="text-sm">Parcialmente</span>
                      </div>
                      <span className="text-sm">{totalParciales} ({Math.round((totalParciales/totalBoletas)*100)}%)</span>
                    </div>
                    <Progress value={(totalParciales/totalBoletas)*100} className="h-2" />
                  </div>
                </CardContent>
              </Card>

              {/* Actividad Reciente */}
              <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl">
                <CardHeader>
                  <CardTitle className="flex items-center space-x-2">
                    <Activity className="w-5 h-5 text-primary" />
                    <span>Actividad Reciente</span>
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    {boletas.slice(0, 4).map((boleta) => (
                      <div key={boleta.id} className="flex items-center space-x-3 p-3 bg-muted/30 rounded-2xl">
                        <div className="w-2 h-2 bg-primary rounded-full"></div>
                        <div className="flex-1 min-w-0">
                          <p className="text-sm truncate">
                            {boleta.fiscalizador} fiscalizó {boleta.placa}
                          </p>
                          <p className="text-xs text-muted-foreground">
                            {boleta.fecha.toLocaleTimeString('es-PE', { 
                              hour: '2-digit', 
                              minute: '2-digit' 
                            })}
                          </p>
                        </div>
                        <Badge className={getConformeColor(boleta.conforme)}>
                          {boleta.conforme}
                        </Badge>
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            </div>
          </TabsContent>

          {/* Inspectores */}
          <TabsContent value="inspectors" className="space-y-6">
            <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl">
              <CardHeader>
                <CardTitle className="flex items-center space-x-2">
                  <Users className="w-5 h-5 text-primary" />
                  <span>Rendimiento de Inspectores</span>
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                  {inspectores.map((inspector) => (
                    <div key={inspector.id} className="p-6 bg-muted/30 rounded-2xl">
                      <div className="flex items-center space-x-3 mb-4">
                        <Avatar className="w-12 h-12">
                          <AvatarFallback className="bg-primary text-white">
                            {inspector.nombre.split(' ').map(n => n[0]).join('')}
                          </AvatarFallback>
                        </Avatar>
                        <div>
                          <h3 className="text-sm">{inspector.nombre}</h3>
                          <p className="text-xs text-muted-foreground">{inspector.codigo}</p>
                        </div>
                      </div>
                      
                      <div className="space-y-3">
                        <div className="flex justify-between items-center">
                          <span className="text-sm text-muted-foreground">Total Boletas</span>
                          <span className="text-sm">{inspector.boletas}</span>
                        </div>
                        <div className="flex justify-between items-center">
                          <span className="text-sm text-muted-foreground">Conformes</span>
                          <span className="text-sm text-green-600">{inspector.conformes}</span>
                        </div>
                        <div className="flex justify-between items-center">
                          <span className="text-sm text-muted-foreground">No Conformes</span>
                          <span className="text-sm text-red-600">{inspector.noConformes}</span>
                        </div>
                        <div className="pt-2">
                          <div className="flex justify-between items-center mb-1">
                            <span className="text-xs text-muted-foreground">Tasa de Conformidad</span>
                            <span className="text-xs">{Math.round((inspector.conformes/inspector.boletas)*100)}%</span>
                          </div>
                          <Progress value={(inspector.conformes/inspector.boletas)*100} className="h-1" />
                        </div>
                        <div className="pt-2 border-t border-border">
                          <p className="text-xs text-muted-foreground">
                            Última actividad: {inspector.ultimaActividad.toLocaleString('es-PE', {
                              day: '2-digit',
                              month: '2-digit',
                              hour: '2-digit',
                              minute: '2-digit'
                            })}
                          </p>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          {/* Registros */}
          <TabsContent value="records" className="space-y-6">
            {/* Filtros */}
            <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl">
              <CardContent className="p-6">
                <div className="flex flex-col md:flex-row gap-4">
                  <div className="flex-1">
                    <div className="relative">
                      <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                      <Input
                        placeholder="Buscar por placa, empresa, conductor..."
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        className="pl-10 rounded-2xl"
                      />
                    </div>
                  </div>
                  <Select value={selectedInspector} onValueChange={setSelectedInspector}>
                    <SelectTrigger className="w-full md:w-48 rounded-2xl">
                      <SelectValue placeholder="Filtrar por inspector" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="all">Todos los inspectores</SelectItem>
                      {inspectores.map((inspector) => (
                        <SelectItem key={inspector.id} value={inspector.codigo}>
                          {inspector.nombre}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                  <Select value={selectedPeriod} onValueChange={setSelectedPeriod}>
                    <SelectTrigger className="w-full md:w-48 rounded-2xl">
                      <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="today">Hoy</SelectItem>
                      <SelectItem value="week">Esta semana</SelectItem>
                      <SelectItem value="month">Este mes</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
              </CardContent>
            </Card>

            {/* Tabla de Registros */}
            <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl">
              <CardContent className="p-6">
                <div className="space-y-4">
                  {filteredBoletas.map((boleta) => (
                    <div key={boleta.id} className="p-4 bg-muted/30 rounded-2xl hover:bg-muted/50 transition-colors">
                      <div className="flex items-center justify-between mb-3">
                        <div className="flex items-center space-x-3">
                          <div className="w-8 h-8 bg-primary/10 rounded-xl flex items-center justify-center">
                            <FileText className="w-4 h-4 text-primary" />
                          </div>
                          <div>
                            <h4 className="text-sm">Placa: {boleta.placa}</h4>
                            <p className="text-xs text-muted-foreground">{boleta.empresa}</p>
                          </div>
                        </div>
                        <div className="flex items-center space-x-2">
                          <Badge className={getConformeColor(boleta.conforme)}>
                            {getConformeIcon(boleta.conforme)}
                            <span className="ml-1">{boleta.conforme}</span>
                          </Badge>
                          <Button variant="ghost" size="sm" className="rounded-xl">
                            <Eye className="w-4 h-4" />
                          </Button>
                        </div>
                      </div>
                      
                      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 text-xs">
                        <div>
                          <span className="text-muted-foreground">Conductor:</span>
                          <p className="truncate">{boleta.conductor}</p>
                        </div>
                        <div>
                          <span className="text-muted-foreground">Licencia:</span>
                          <p>{boleta.numeroLicencia}</p>
                        </div>
                        <div>
                          <span className="text-muted-foreground">Inspector:</span>
                          <p>{boleta.fiscalizador}</p>
                        </div>
                        <div>
                          <span className="text-muted-foreground">Fecha:</span>
                          <p>{boleta.fecha.toLocaleString('es-PE', {
                            day: '2-digit',
                            month: '2-digit',
                            hour: '2-digit',
                            minute: '2-digit'
                          })}</p>
                        </div>
                      </div>
                      
                      <div className="mt-3 pt-3 border-t border-border">
                        <p className="text-xs text-muted-foreground mb-1">Motivo:</p>
                        <p className="text-xs">{boleta.motivo}</p>
                        {boleta.descripciones && (
                          <>
                            <p className="text-xs text-muted-foreground mt-2 mb-1">Descripciones:</p>
                            <p className="text-xs">{boleta.descripciones}</p>
                          </>
                        )}
                        {boleta.observaciones && (
                          <>
                            <p className="text-xs text-muted-foreground mt-2 mb-1">Observaciones:</p>
                            <p className="text-xs text-red-600">{boleta.observaciones}</p>
                          </>
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          {/* Fotos */}
          <TabsContent value="photos" className="space-y-6">
            <Card className="border-0 shadow-lg shadow-primary/10 rounded-3xl">
              <CardHeader>
                <CardTitle className="flex items-center space-x-2">
                  <Camera className="w-5 h-5 text-primary" />
                  <span>Galería de Licencias</span>
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                  {boletas.filter(b => b.fotoLicencia).map((boleta) => (
                    <div key={boleta.id} className="bg-muted/30 rounded-2xl overflow-hidden">
                      <div className="aspect-video relative">
                        <img
                          src={boleta.fotoLicencia}
                          alt={`Licencia de ${boleta.conductor}`}
                          className="w-full h-full object-cover"
                        />
                        <div className="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent"></div>
                        <div className="absolute bottom-2 left-2 right-2">
                          <Badge className={`${getConformeColor(boleta.conforme)} mb-1`}>
                            {getConformeIcon(boleta.conforme)}
                            <span className="ml-1">{boleta.conforme}</span>
                          </Badge>
                        </div>
                      </div>
                      <div className="p-4">
                        <h4 className="text-sm mb-1">{boleta.conductor}</h4>
                        <p className="text-xs text-muted-foreground mb-2">
                          Licencia: {boleta.numeroLicencia}
                        </p>
                        <div className="flex items-center justify-between text-xs">
                          <span className="text-muted-foreground">Placa: {boleta.placa}</span>
                          <span className="text-muted-foreground">
                            {boleta.fecha.toLocaleDateString('es-PE')}
                          </span>
                        </div>
                        <div className="mt-2">
                          <p className="text-xs text-muted-foreground">Inspector: {boleta.fiscalizador}</p>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
                
                {boletas.filter(b => b.fotoLicencia).length === 0 && (
                  <div className="text-center py-12">
                    <Camera className="w-12 h-12 text-muted-foreground mx-auto mb-4" />
                    <h4 className="text-muted-foreground mb-2">No hay fotos disponibles</h4>
                    <p className="text-sm text-muted-foreground">
                      Las fotos de licencias aparecerán aquí cuando se capturen durante las fiscalizaciones
                    </p>
                  </div>
                )}
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>
      </main>
    </div>
  );
}