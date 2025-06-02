package com.revision.ExceptionHandlers;

import com.revision.ExceptionHandlers.Exceptions.NotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.sql.Timestamp;
import java.time.LocalDateTime;

@ControllerAdvice
public class ExceptionController {

    @ExceptionHandler(value = NotFoundException.class)
    public ResponseEntity<?> handleNotFound(NotFoundException notFound){

        ExceptionDTO exceptionDTO = new ExceptionDTO(notFound.getMessage(), HttpStatus.BAD_REQUEST.value(), LocalDateTime.now().toString());

        return ResponseEntity.badRequest().body(exceptionDTO);
    }

}
