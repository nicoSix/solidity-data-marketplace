import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { CreateSLAComponent } from './component/create-sla/create-sla.component';
import { FormBuilder } from '@angular/forms';
import { RouterModule, Routes } from '@angular/router';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { EthcontractService } from './ethcontract.service';
import { CreateSLAService } from './service/create-sla.service';




@NgModule({
  declarations: [
    AppComponent,
    CreateSLAComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    ReactiveFormsModule,

    
    
  ],
  providers: [FormBuilder,
  EthcontractService,
  CreateSLAService
],
  bootstrap: [AppComponent]
})
export class AppModule { }
