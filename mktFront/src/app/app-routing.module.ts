import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { CreateSLAComponent } from './component/create-sla/create-sla.component';
import {ReactiveFormsModule, FormsModule } from '@angular/forms';



const routes: Routes = [
  {path: 'createSLA', component: CreateSLAComponent },
  
];


export const appRouting = RouterModule.forRoot(routes);

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
