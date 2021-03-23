import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CreateSLAComponent } from './create-sla.component';

describe('CreateSLAComponent', () => {
  let component: CreateSLAComponent;
  let fixture: ComponentFixture<CreateSLAComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CreateSLAComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CreateSLAComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
